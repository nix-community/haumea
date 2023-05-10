# Haumea

Filesystem-based module system for Nix

Haumea is not related to or a replacement for NixOS modules.
It is closer to the module systems of traditional programming languages,
with support for file hierarchy and visibility.

In short, haumea maps a directory of Nix files into an attribute set:

<table align="center">
<thead>
  <tr>
    <th>From</th>
    <th>To</th>
  </tr>
</thead>
<tr>
  <td>

```
├─ foo/
│  ├─ bar.nix
│  ├─ baz.nix
│  └─ __internal.nix
├─ bar.nix
└─ _utils/
   └─ foo.nix
```

  </td>
  <td>

```nix
{
  foo = {
    bar = <...>;
    baz = <...>;
  };
  bar = <...>;
}
```

  </td>
</tr>
</table>

Haumea's source code is hosted on [GitHub](https://github.com/nix-community/haumea)
under the [MPL-2.0](http://mozilla.org/MPL/2.0) license.
Haumea bootstraps itself. You can see the entire implementation in the
[src](https://github.com/nix-community/haumea/tree/main/src) directory.

## Why Haumea?

- No more manual imports

  Manually importing files can be tedious, especially when there are many of them.
  Haumea takes care of all of that by automatically importing the files into an attribute set.

- Modules

  Haumea takes inspiration from traditional programming languages.
  Visibility makes it easy to create utility modules,
  and haumea makes self-referencing and creating fixed points a breeze
  with the introduction of `self`, `super`, and `root`.

- Organized directory layout

  What you see is what you get.
  By default[^1], the file tree will look exactly like the resulting attribute set.

- Extensibility

  Changing how the files are loaded is as easy as specifying a `loader`,
  and the `transformer` option makes it possible to extensively manipulate the tree.

[^1]: Unless you are doing transformer magic
