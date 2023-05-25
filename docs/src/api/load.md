# `load`

Source: [`src/load.nix`](https://github.com/nix-community/haumea/blob/main/src/load.nix)

Type: `{ src, loader?, inputs?, transformer? } -> { ... }`

Arguments:

- `src` : `Path`

  The directory to load files from.

- (optional) `loader` : `{ self, super, root, ... } -> Path -> a`

  Loader for the files, defaults to [`loaders.default`](loaders.html#loadersdefault).

- (optional) `inputs` : `{ ... }`

  Extra inputs to be passed to the loader.

  `self`, `super`, and `root` are reserved names that cannot be passed as an input.
  To work around that, remove them using `removeAttrs`, or pass them by overriding the loader.

- (optional) `transformer` : `(cursor : [ String ]) -> { ... } -> a` or a list of transformers

  Module transformer, defaults to `[ ]` (no transformation).
  This will transform each directory module in `src`, including the root.
  `cursor` represents the position of the directory being transformed,
  where `[ ]` means root and `[ "foo" "bar" ]` means `root.foo.bar`.

Nix files found in `src` are loaded into an attribute set with the specified `loader`.
As an example, the entirety of haumea's API is `load`ed from the
[src](https://github.com/nix-community/haumea/tree/main/src) directory.

For a directory like this:

```
src
├─ foo/
│  ├─ bar.nix
│  ├─ baz.nix
│  └─ __internal.nix
├─ bar.nix
└─ _utils/
   └─ foo.nix
```

The output will look like this:

```nix
{
  foo = {
    bar = <...>;
    baz = <...>;
  };
  bar = <...>;
}
```

Notice that there is no `utils`.
This is because files and directories that start with `_` are only visible
inside the directory being loaded, and will not be present in the final output.

Similarly, files and directories that start with `__` are only visible if they are in the same directory,
meaning `foo/__internal.nix` is only accessible if it is being accessed from within `foo`.

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
Accessing `self.b` here would cause infinite recursion,
and accessing anything else would fail due to missing attributes.

`super` will be `{ bar = self; baz = <...>; internal = <...>; }`.

And `root` will be:

```nix
{
  # foo = super;
  foo = {
    bar = <...>;
    baz = <...>;
    internal = <...>;
  };
  baz = <...>;
  utils.foo = <...>;
}
```

Note that this is different from the return value of `load`.
`foo.internal` is accessible here because it is being accessed from within `foo`.
Same for `utils`, which is accessible from all files within `src`, the directory being loaded.
