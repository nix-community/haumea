{ lib }:

let
  inherit (lib)
    callPackageWith
    ;
in

inputs: path: callPackageWith inputs path { }
