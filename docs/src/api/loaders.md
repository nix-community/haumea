# Loaders

## `loaders.callPackage`

Source: [`src/loaders/callPackage.nix`](https://github.com/nix-community/haumea/blob/main/src/loaders/callPackage.nix)

Type: `{ self, super, root, ... } -> Path -> a`

A wrapper around `callPackageWith`.
It adds `override` and `overrideDerivation` to the output (as `makeOverridable` does),
and requires the file being loaded to be a function that returns an attribute set.
Unlike [`loaders.default`], it will respect optional function arguments,
as they can be overridden with the added `override` attribute.

## `loaders.default`

Source: [`src/loaders/default.nix`](https://github.com/nix-community/haumea/blob/main/src/loaders/default.nix)

Type: `{ self, super, root, ... } -> Path -> a`

This is the default loader.
It imports the file, and provides it the necessary inputs if the file is a function.

Default values of optional function arguments will be ignored, e.g.
for `{ foo ? "bar" }: foo`, `"bar"` will be ignored, and it requires `inputs` to contain `foo`.
For that reason, although not strictly forbidden, optional arguments are discouraged since they are no-ops.

## `loaders.path`

Source: [`src/loaders/path.nix`](https://github.com/nix-community/haumea/blob/main/src/loaders/path.nix)

Type: `{ ... } -> Path -> Path`

This loader will simply return the path of the file without `import`ing it.

## `loaders.scoped`

Source: [`src/loaders/scoped.nix`](https://github.com/nix-community/haumea/blob/main/src/loaders/scoped.nix)

Type: `{ self, super, root, ... } -> Path -> a`

This is like [`loaders.default`], except it uses `scoepdImport` instead of `import`.
With this loader, you don't have to explicitly declare the inputs with a lambda,
since `scopedImport` will take care of it as if the file being loaded is wrapped with `with inputs;`.

## `loaders.verbatim`

Source: [`src/loaders/verbatim.nix`](https://github.com/nix-community/haumea/blob/main/src/loaders/verbatim.nix)

Type: `{ ... } -> Path -> a`

This loader will simply `import` the file without providing any input.
It is useful when the files being loaded are mostly functions that don't require any external input.

[`loaders.default`]: #loadersdefault
