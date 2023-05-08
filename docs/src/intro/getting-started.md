# Getting Started

Haumea comes with a template for a simple Nix library.
You can try out the template with:

```bash
nix flake init -t github:nix-community/haumea
```

This will generate `flake.nix` and some other relevant files in the current directory.
Or if you want to create a new directory for this, run:

```bash
nix flake new <dir> -t github:nix-community/haumea
```

You can use haumea without the template by adding it to your flake inputs:

```nix
{{#include ../../../templates/default/flake.nix:2:8}}
```

Haumea is pinged to a tag here so potential breaking changes in the main branch
wouldn't break downstream consumers.
See the [Versioning](versioning.html) chapter for information.

The rest of this chapter will be using this template.

---

In `flake.nix`, the main thing you want to look at is `lib`:

```nix
{{#include ../../../templates/default/flake.nix:18:23}}
```

`haumea.lib.load` is the main entry point of haumea.
It loads a directory (`./src`) of Nix files into an attribute set.
You can see the result of this by running `nix eval .#lib`:

```nix
{ answer = 42; }
```

If you open `src/answer.nix`, you can see that it is a lambda that returns 42.

```nix
{{#include ../../../templates/default/src/answer.nix}}
```

The `lib` here is provided by the `inputs` option of [`load`]:

```nix
{{#include ../../../templates/default/flake.nix:20:22}}
```

The `lib.id 42` in `answer.nix` becomes `nixpkgs.lib.id 42`, which evaluates to 42.

By default, the file doesn't have to specify the inputs that it does not use,
or even specify any inputs at all if it is not using any inputs.
Both `{ }: 42` and `42` are valid in this case and will do exactly the same thing.

`self`, `super`, and `root` are special inputs that are always available.
You might already be familiar with them based on the names.
These names are reserved, haumea will throw an error if you try to override them.

The documentation for [`load`] explains this more thoroughly and talks about some workarounds.

`checks` works basically the same, just with
[`loadEvalTests`](../api/loadEvalTests.html) instead of [`load`].
You can run the checks with `nix flake check`.

[`load`]: ../api/load.html
