{ lib, super }:

super.extension "toml" (_: lib.importTOML)
