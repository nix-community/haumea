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
      matchers.nix = import ./src/matchers/nix.nix {
        super.extension = import ./src/matchers/extension.nix {
          inherit lib;
        };
      };
      parsePath = import ./src/__parsePath.nix {
        inherit lib;
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
