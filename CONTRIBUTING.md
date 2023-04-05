# Contributing to Haumea

Unless explicitly stated, all contributions are licensed under
[MPL-2.0](http://mozilla.org/MPL/2.0), the license used by haumea.

## Making Changes to the API

This doesn't apply to bug fixes.

- Discuss before opening a pull request, so your work doesn't go to waste.
  Anything from GitHub issues to Matrix discussions are fine.
- Update documentation accordingly. Everything in `haumea.lib` should to be documented.
- Add [tests](tests) when necessary.
  Test your changes with `nix flake check`. Make sure new files are added to git.

## Scope

Haumea only depends on [nixpkgs.lib](https://github.com/nix-community/nixpkgs.lib).
Features that depend on the rest of [nixpkgs] should not be added.
However, changes that are specific to, but doesn't depend on [nixpkgs] are allowed.

## Style

- Format all Nix files with [nixpkgs-fmt](https://github.com/nix-community/nixpkgs-fmt).
- `with` should be avoided unless absolutely necessary,
  `let inherit` is preferred at almost all times.
- `rec` attribute sets should be avoid at most times, use `self` or `let-in` instead.

[nixpkgs]: https://github.com/nixos/nixpkgs
