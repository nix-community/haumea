# Matchers

Type: `{ matches, loader }`

Matchers map matches to loaders.

## `matchers.always`

Source: [`src/matchers/always.nix`](https://github.com/nix-community/haumea/blob/main/src/matchers/always.nix)

Type: `loader -> matcher`

Matches any file and extension. Use last as catch-all.

## `matchers.regex`

Source: [`src/matchers/regex.nix`](https://github.com/nix-community/haumea/blob/main/src/matchers/regex.nix)

Type: `regex -> loader -> matcher`

Matches the regex, matching group matches are made available to the loader.

## `matchers.nix`

Source: [`src/matchers/nix.nix`](https://github.com/nix-community/haumea/blob/main/src/matchers/nix.nix)

Type: `loader -> matcher`

Matches files that end in `.nix`. This is the default matcher if no matchers are defined.
