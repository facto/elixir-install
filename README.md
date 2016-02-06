# elixir-install

Installs Elixir. That's it. That's all this does.

## Features

- [ ] Supports installing arbitrary versions.
- [ ] Supports downloading the latest versions from [elixir-versions](https://github.com/facto/elixir-versions).
- [ ] Supports installing into `/opt/elixirs` for root and `~/.elixirs` for users by default.
- [ ] Supports installing into arbitrary directories.
- [ ] Supports downloading archives using `wget` or `curl`.
- [ ] Supports verifying downloaded archives using `md5sum`, `md5`, or `openssl md5`.
- [ ] Has tests.

## Anti-Features

- [ ] Does not require updating every time a new Elixir version comes out.
- [ ] Does not require recipes for each individual Elixir version or configuration.
- [ ] Does not support installing trunk/HEAD.

## Requiremets

- [bash](http://www.gnu.org/software/bash/) >= 3.x
- [wget](http://www.gnu.org/software/wget/) or [curl](http://curl.haxx.se/)
- `tar`
- `bzip2`

## Synopsis

List supported Elixirs and their major versions:

    $ elixir-install

List the latest versions:

    $ elixir-install --latest

Install the latest version of Elixir:

    $ elixir-install --latest elixir

Install a specific version of Elixir:

    $ elixir-install elixir 1.2.2

Install an Elixir into a specific directory:

    $ elixir-install --install-dir /path/to/dir elixir

Install an Elixir into a specific `elixirs` directory:

    $ elixir-install --elixirs-dir /path/to/elixirs/ elixir

Uninstall an Elixir version:

    $ rm -rf ~/.elixirs/elixir-1.1.0
