#!/usr/bin/env bash

shopt -s extglob

elixir_install_version="0.1.0"
elixir_install_dir="${BASH_SOURCE[0]%/*}"
elixir_install_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/elixir-install"

elixirs=(elixir)
patches=()
configure_opts=()
make_opts=()

if (( UID == 0 )); then
  src_dir="/usr/local/src"
  elixirs_dir="/opt/elixirs"
else
  src_dir="$HOME/src"
  elixirs_dir="$HOME/.elixirs"
fi

source "$elixir_install_dir/util.sh"
source "$elixir_install_dir/elixir-versions.sh"

#
# Prints usage information for elixir-install.
#
function usage()
{
  cat <<USAGE
usage: elixir-install [OPTIONS] [ELIXIR] [VERSION] [-- CONFIGURE_OPTS ...]]

Options:

  -e, --elixirs-dir   DIR Directory that contains other installed Elixirs
  -i, --install-dir   DIR Directory to install Elixir into
      --prefix DIR    Alias for -i DIR
  -s, --src-dir DIR   Directory to download source-code into
  -c, --cleanup       Remove archive and unpacked source-code after installation
  --no-reinstall      Skip installation if another Elixir is detected in same location
  -L, --latest        Downloads the latest Elixir versions
  -V, --version       Prints the version
  -h, --help          Prints this message

Examples:

  $ elixir-install elixir
  $ elixir-install elixir 2.3
  $ elixir-install elixir 2.3.0

USAGE
}

#
# Parses an "elixir-version" string.
#
function parse_elixir()
{
  local arg="$1"

  case "$arg" in
    *-*)
      elixir="${arg%%-*}"
      elixir_version="${arg#*-}"
      ;;
    *)
      elixir="${arg}"
      elixir_version=""
      ;;
  esac

  if [[ ! "${elixirs[@]}" == *"$elixir"* ]]; then
    error "Unknown elixir: $elixir"
    return 1
  fi
}

#
# Parses command-line options for elixir-install.
#
function parse_options()
{
  local argv=()

  while [[ $# -gt 0 ]]; do
    case $1 in
      -e|--elixirs-dir)
        elixirs_dir="$2"
        shift 2
        ;;
      -i|--install-dir|--prefix)
        install_dir="$2"
        shift 2
        ;;
      -s|--src-dir)
        src_dir="$2"
        shift 2
        ;;
      -c|--cleanup)
        cleanup=1
        shift
        ;;
      --no-reinstall)
        no_reinstall=1
        shift
        ;;
      -L|--latest)
        force_update=1
        shift
        ;;
      -V|--version)
        echo "elixir-install: $elixir_install_version"
        exit
        ;;
      -h|--help)
        usage
        exit
        ;;
      --)
        shift
        configure_opts=("$@")
        break
        ;;
      -*)
        echo "elixir-install: unrecognized option $1" >&2
        return 1
        ;;
      *)
        argv+=($1)
        shift
        ;;
    esac
  done

  case ${#argv[*]} in
    2)  parse_elixir "${argv[0]}-${argv[1]}" || return $? ;;
    1)  parse_elixir "${argv[0]}" || return $? ;;
    0)  return 0 ;;
    *)
      echo "elixir-install: too many arguments: ${argv[*]}" >&2
      usage 1>&2
      return 1
      ;;
  esac
}

#
# Prints Elixirs supported by elixir-install.
#
function list_elixirs()
{
  local elixir

  for elixir in "${elixirs[@]}"; do
    if [[ $force_update -eq 1 ]] ||
       are_elixir_versions_missing "$elixir"; then
      log "Downloading latest $elixir versions ..."
      download_elixir_versions "$elixir"
    fi
  done

  echo "Elixir versions:"
  for elixir in "${elixirs[@]}"; do
    echo "  $elixir:"
    elixir_versions "$elixir" | sed -e 's/^/    /' || return $?
  done
}

#
# Initializes variables.
#
function init()
{
  local fully_qualified_version="$(lookup_elixir_version "$elixir" "$elixir_version")"

  if [[ -n "$fully_qualified_version" ]]; then
    elixir_version="$fully_qualified_version"
  else
    warn "Unknown $elixir version $elixir_version. Proceeding anyway ..."
  fi

  elixir_cache_dir="$elixir_install_cache_dir/$elixir"
  install_dir="${install_dir:-$elixirs_dir/$elixir-$elixir_version}"

  source "$elixir_install_dir/functions.sh"       || return $?
  source "$elixir_install_dir/$elixir/functions.sh" || return $?
}
