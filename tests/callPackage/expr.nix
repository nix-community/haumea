{ haumea, lib }:

let
  loaded = haumea.load {
    src = ./__fixture;
    loader = haumea.loaders.callPackage;
    inputs = {
      inherit lib;
    };
  };

  inherit (loaded) foo;
in

{
  foo = foo.value;
  bar = (foo.override {
    value = "bar";
  }).value;
}
