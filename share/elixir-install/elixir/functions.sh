#!/usr/bin/env bash

elixir_archive="v$elixir_version.tar.gz"
elixir_dir_name="elixir-$elixir_version"
elixir_mirror="${elixir_mirror:-https://github.com/elixir-lang/elixir/archive}"
elixir_url="${elixir_url:-$elixir_mirror/$elixir_archive}"

#
# Cleans Elixir.
#
function clean_elixir()
{
  log "Cleaning Elixir $elixir_version ..."
  make clean || return $?
}

#
# Compiles Elixir.
#
function compile_elixir()
{
  log "Compiling Elixir $elixir_version ..."
  make "${make_opts[@]}" || return $?
}

#
# Installs Elixir into $install_dir
#
function install_elixir()
{
  log "Installing Elixir $elixir_version ..."
  make install || return $?
}
