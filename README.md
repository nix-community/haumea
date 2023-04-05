# Haumea

Filesystem-based module system for Nix

Haumea is not related to or a replacement for NixOS modules.
It is closer to the module systems of traditional programming languages,
with support for file hierarchy and visibility.

```bash
nix flake init -t github:nix-community/haumea
```

## Versioning

Haumea follows [semantic versioning](https://semver.org).
Breaking changes can happen in main branch at any time,
so it is recommended to pin haumea to a specific tag.
A list of available versions can be found on the
[releases](https://github.com/nix-community/haumea/releases) page.

## Usage

### [`load`](src/load.nix)

Type: `{ src, loader?, inputs?, transformer? } -> { ... }`

Arguments:

- `src` : `Path`

  The directory to load files from.

- (optional) `loader` : `{ self, super, root, ... } -> Path -> a`

  Loader for the files, defaults to [`loaders.default`].

- (optional) `inputs` : `{ ... }`

  Extra inputs to be passed to the loader.

  `self`, `super`, and `root` are reserved names that cannot be passed as an input.
  To work around that, remove them using `removeAttrs`, or pass them by overriding the loader.

- (optional) `transformer` : `{ ... } -> a`

  Module transformer, defaults to `id` (no transformation).
  This will transform each directory module in `src`, including the root.

The main entry point of haumea. This is probably the function you are looking for.

Nix files found in `src` are loaded into an attribute set with the specified `loader`.
As an example, the entirety of haumea's API is `load`ed from the [src](src) directory.

For a directory like this:

```
<src>
├─ foo/
│  ├─ bar.nix
│  └─ __baz.nix
├─ _bar/
│  └─ baz.nix
└─ baz.nix
```

The output will look like this:

```nix
{
  foo.bar = <...>;
  baz = <...>;
}
```

Notice that there is no `bar.baz`.
This is because files and directories that start with `_` are only visible inside the directory being loaded,
and will not be present in the final output.

Similarly, files and directories that start with `__` are only visible if they are in the same directory,
meaning `foo/__bar.nix` is only accessible if it is being accessed from within `foo`.

By default, the specified `inputs`, in addition to `self`, `super`, and `root`,
will be passed to the file being loaded, if the file is a function.

- `self` represents the current file.
- `super` represents the directory the file is in.
- `root` represents the root of the `src` directory being loaded.

Continuing the example above, this is the content of `foo/bar.nix` (`super` and `root` are unused, they are just here for demonstration purposes):

```nix
{ self, super, root }:

{
  a = 42;
  b = self.a * 2;
}
```

`self.a` will be `42`, which will make `b` `84`.
Accessing anything other than `self.a` (e.g. `self.c`) will cause infinite recursion.

`super` will be `{ bar = self; baz = <...>; }`.

And `root` will be:

```nix
{
  # foo = super;
  foo = {
    bar = <...>;
    baz = <...>;
  };
  baz = <...>;
}
```

Note that this is different from the return value of `load`.
`foo.baz` is accessible here because it is being accessed from within `foo`;

### [`loadEvalTests`](src/loadEvalTests.nix)

Type: `{ src, loader?, inputs? } -> { }`

A wrapper around [`load`] to run eval tests using
[`runTests`](https://nixos.org/manual/nixpkgs/unstable/#function-library-lib.debug.runTests).

The accepted arguments are exactly the same as [`load`].

This function will throw an error if at least one test failed,
otherwise it will always return `{ }` (an empty attribute set).

As an example, haumea's [tests](tests) are loaded with `loadEvalTests`.

### [`loaders.callPackage`](src/loaders/callPackage.nix)

Type: `{ self, super, root, ... } -> Path -> a`

A wrapper around `callPackageWith`.
It adds `override` and `overrideDerivation` to the output (as `makeOverridable` does),
and requires the file being loaded to be a function that returns an attribute set.
Unlike [`loaders.default`], it will respect optional function arguments,
as they can be overridden with the added `override` attribute.

### [`loaders.default`](src/loaders/default.nix)

Type: `{ self, super, root, ... } -> Path -> a`

This is the default loader.
It imports the file, and provides it the necessary inputs if the file is a function.

Default values of optional function arguments will be ignored, e.g.
for `{ foo ? "bar" }: foo`, `"bar"` will be ignored, and it requires `inputs` to contain `foo`.
For that reason, although not strictly forbidden, optional arguments are discouraged since they are no-ops.

### [`loaders.path`](src/loaders/path.nix)

Type: `{ ... } -> Path -> Path`

This loader will simply return the path of the file without `import`ing it.

### [`loaders.verbatim`](src/loaders/verbatim.nix)

Type: `{ ... } -> Path -> a`

This loader will simply `import` the file without providing any input.
It is useful when the files being loaded are mostly functions that don't require any external input.

### [`transformers.liftDefault`](src/transformers/liftDefault.nix)

Type: `{ ... } -> { ... }`

This transformer will lift the contents of `default` into the module.
It will fail if `default` is not an attribute set,
or has any overlapping attributes with the module.

## Alternatives

[std](https://github.com/divnix/std) is a more full-featured framework that also has filesystem-based auto-importing.
Haumea has very different goals, with more focus on Nix libraries.

[digga](https://github.com/divnix/digga) has similar functionality via `rakeLeaves`,
but it is more focused on system and home configurations,
and haumea has more features in this specific aspect.

[`load`]: #load
[`loaders.default`]: #loadersdefault
