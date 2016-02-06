#!/usr/bin/env bash

source "$elixir_install_dir/versions.sh"

elixir_versions_url="https://raw.githubusercontent.com/facto/elixir-versions/master"
elixir_versions_files=(versions.txt)

#
# Determines if the elixir-versions files are missing for a elixir.
#
function are_elixir_versions_missing()
{
  local dir="$elixir_install_cache_dir/$elixir"

  if [[ ! -d "$dir" ]]; then
    return 0
  fi

  local file

  for file in "${elixir_versions_files[@]}"; do
    if [[ ! -f "$dir/$file" ]]; then
      return 0
    fi
  done

  return 1
}

#
# Downloads a file from the elixir-versions repository.
#
function download_elixir_versions_file()
{
  local elixir="$1"
  local elixir_name="${elixir}"

  local file="$2"
  local dir="$elixir_install_cache_dir/$elixir"
  local dest="$dir/$file"

  local url="$elixir_versions_url/$elixir_name/$file"

  if [[ -f "$dest" ]]; then rm "$dest"      || return $?
  else                      mkdir -p "$dir" || return $?
  fi

  local ret

  download "$url" "$dest" >/dev/null 2>&1
  ret=$?

  if (( ret > 0 )); then
    error "Failed to download $url to $dest!"
    return $ret
  fi
}

#
# Downloads all elixir-versions files for a elixir.
#
function download_elixir_versions()
{
  local elixir="$1"

  for file in "${elixir_versions_files[@]}"; do
    download_elixir_versions_file "$elixir" "$file" || return $?
  done
}

#
# Finds the closest matching version.
#
function latest_elixir_version()
{
  local elixir="$1"
  local version="$2"

  latest_version "$elixir_install_cache_dir/$elixir/versions.txt" "$version"
}

#
# Determines if the given version is a known version.
#
function is_known_elixir_version()
{
  local elixir="$1"
  local version="$2"

  is_known_version "$elixir_install_cache_dir/$elixir/versions.txt" "$version"
}

#
# Lists all current versions.
#
function elixir_versions()
{
	local elixir="$1"

	cat "$elixir_install_cache_dir/$elixir/versions.txt"
}

#
# Resolves a short-hand elixir version to a fully qualified version.
#
function lookup_elixir_version()
{
  local elixir="$1"
  local version="$2"

  if is_known_elixir_version "$elixir" "$version"; then
    echo -n "$version"
  else
    latest_elixir_version "$elixir" "$version"
  fi
}
