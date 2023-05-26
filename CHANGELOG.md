# Changelog

## v0.2.2 - 2023-05-26

### Features

- New [book](https://nix-community.github.io/haumea)
- load: `loader` now also accepts a list of matchers for loading non-Nix files
  ([#10](https://github.com/nix-community/haumea/pull/10))

  The following matchers and functions available under
  [`matchers`](https://nix-community.github.io/haumea/api/matchers.html):

  - `always` always matches the file regardless of its file name
  - `extension` matches the file by its extension
  - `json` loads all JSON files
  - `nix` is the default matcher if the `loader` is a function and not a list of matchers
  - `regex` matches the file using the given regex
  - `toml` loads all TOML files

## v0.2.1 - 2023-04-19

### Features

- `loaders.scoped` to utilize `scopedImport` instead of `import` for loading files

## v0.2.0 - 2023-04-10

### Breaking Changes

- Transformers now accept a ccursor as an argument.
  The type signature of `transformer` have changed
  from `{ ... } -> a` to `[ String ] -> { ... } -> a`

### Features

- `transformers.hoistAttrs` and `transformers.hoistLists`
  bring a specific attribute name at all levels to the root.
- load: `transformer` now also accepts a list or a nested list of functions.

## v0.1.1 - 2023-04-07

### Features

- load: add transformer option
- transformers: add liftDefault

## v0.1.0 - 2023-04-01

First release
