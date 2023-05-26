{ lib }:

let
  inherit (builtins)
    stringLength
    ;
  inherit (lib)
    hasSuffix
    ;
in

f: {
  matches = file: hasSuffix ".nix" file && stringLength file > 4;
  loader = f;
}
