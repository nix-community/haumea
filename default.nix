{ lib ? import <nixpkgs/lib> }:

let
  load = import ./src/load.nix {
    inherit lib;
    root.loaders.default = import ./src/loaders {
      inherit lib;
    };
  };
in

load {
  src = ./src;
  inputs = {
    inherit lib;
  };
}
