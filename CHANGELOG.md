# Changelog

## v0.2.0 - 2023-04-10

## Breaking Changes

- Transformers now accept a ccursor as an argument.
  The type signature of `transformer` have changed
  from `{ ... } -> a` to `[ String ] -> { ... } -> a`

## Features

- `transformers.hoistAttrs` and `transformers.hoistLists`
  bring a specific attribute name at all levels to the root.
- load: `transformer` now also accepts a list or a nested list of functions.

## v0.1.1 - 2023-04-07

## Features

- load: add transformer option
- transformers: add liftDefault

## v0.1.0 - 2023-04-01

First release
