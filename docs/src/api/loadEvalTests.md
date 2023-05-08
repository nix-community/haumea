# `loadEvalTests`

Source: [`src/loadEvalTests.nix`](https://github.com/nix-community/haumea/blob/main/src/loadEvalTests.nix)

Type: `{ src, loader?, inputs? } -> { }`

A wrapper around [`load`] to run eval tests using
[`runTests`](https://nixos.org/manual/nixpkgs/unstable/#function-library-lib.debug.runTests).

The accepted arguments are exactly the same as [`load`].

This function will throw an error if at least one test failed,
otherwise it will always return `{ }` (an empty attribute set).

As an example, haumea's [tests](https://github.com/nix-community/haumea/tree/main/tests)
are loaded with `loadEvalTests`.

Alternatively, [namaka](https://github.com/nix-community/namaka)
provides utilities for snapshot testing,
which can save you some time from writing reference values.

[`load`]: load.html
