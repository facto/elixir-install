#!/usr/bin/env bash

#
# Pre-install tasks
#
function pre_install()
{
  mkdir -p "$src_dir" || return $?
  mkdir -p "${install_dir%/*}" || return $?
}

#
# Download the Elixir archive
#
function download_elixir()
{
  log "Downloading $elixir_url into $src_dir ..."
  download "$elixir_url" "$src_dir/$elixir_archive" || return $?
}

#
# Extract the Elixir archive
#
function extract_elixir()
{
  log "Extracting $elixir_archive to $src_dir/$elixir_dir_name ..."
  extract "$src_dir/$elixir_archive" "$src_dir" || return $?
}

#
# Place holder function for configuring Elixir.
#
function configure_elixir() { return; }

#
# Place holder function for cleaning Elixir.
#
function clean_elixir() { return; }

#
# Place holder function for compiling Elixir.
#
function compile_elixir() { return; }

#
# Place holder function for installing Elixir.
#
function install_elixir() { return; }

#
# Place holder function for post-install tasks.
#
function post_install() { return; }

#
# Remove downloaded archive and unpacked source.
#
function cleanup_source() {
  log "Removing $src_dir/$elixir_archive ..."
  rm "$src_dir/$elixir_archive" || return $?

  log "Removing $src_dir/$elixir_dir_name ..."
  rm -rf "$src_dir/$elixir_dir_name" || return $?
}
