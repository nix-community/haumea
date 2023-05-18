{ lib ? import <nixpkgs/lib> }:

let
  load = import ./src/load.nix {
    inherit lib;
    root = {
      loaders.default = import ./src/loaders {
        super.defaultWith = import ./src/loaders/__defaultWith.nix {
          inherit lib;
        };
      };
      matchers.nixFiles = import ./src/matchers/nixFiles.nix {
        super.regex = import ./src/matchers/regex.nix { };
      };
    };
  };
in

load {
  src = ./src;
  inputs = {
    inherit lib;
  };
}
