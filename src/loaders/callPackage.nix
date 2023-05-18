{ lib }:

let
  inherit (lib)
    callPackageWith
    ;
in

_: inputs: path: callPackageWith inputs path { }
