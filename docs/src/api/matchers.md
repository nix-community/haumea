# Matchers

Type: `{ matches : String -> Bool, loader : { self, super, root, ... } -> Path -> a }`

Matchers allows non-Nix files to be loaded.

This is used for the `loader` option of [`load`],
which will find the first matcher where `matches` returns `true`,
and use its `loader` to load the file.

`matches` takes the name of the file with (up to 2) extra preceding `_`s removed.
For both `bar.nix` and `foo/__bar.nix`, the string `matches` gets will be `bar.nix`.

`loader` works exactly like passing a function to the `loader` option,
the only difference is that the matcher interface allows loading non-Nix files.

When using matchers, the attribute name will be the file name without its extension,
which will be `foo` for all of the following files:

- `foo.nix`
- `bar/_foo.nix`
- `baz/foo`

Only the last file extension is removed,
so `far.bar.baz` will have an attribute name of `foo.bar`.

## `matchers.always`

Source: [`src/matchers/always.nix`](https://github.com/nix-community/haumea/blob/main/src/matchers/always.nix)

Type: `({ self, super, root, ... } -> Path -> a }) -> Matcher`

Matches any file name. This can be used as the last matcher as a catch-all.

## `matchers.extension`

Source: [`src/matchers/extension.nix`](https://github.com/nix-community/haumea/blob/main/src/matchers/extension.nix)

Type: `String -> ({ self, super, root, ... } -> Path -> a }) -> Matcher`

Matches files with the given extension.
`matchers.extension "foo"` matches `a.foo` and `a.b.foo`, but not `.foo`.

## `matchers.nix`

Source: [`src/matchers/nix.nix`](https://github.com/nix-community/haumea/blob/main/src/matchers/nix.nix)

Type: `({ self, super, root, ... } -> Path -> a }) -> Matcher`

Matches files that end in `.nix`. This is equivalent to `matchers.extension "nix"`.

This is the default matcher if no matchers are defined.

## `matchers.regex`

Source: [`src/matchers/regex.nix`](https://github.com/nix-community/haumea/blob/main/src/matchers/regex.nix)

Type: `(regex : String) -> ([ String ] -> { self, super, root, ... } -> Path -> a }) -> Matcher`

Matches the file name using the given regex.
Instead of a regular loader, the function will also take the regex matches
returned by `builtins.match`, as shown in the type signature (`[ String ]`).

[`load`]: load.html
