{ lib }:

let
  inherit (builtins)
    stringLength
    ;
  inherit (lib)
    hasSuffix
    ;
in

ext: f: {
  matches = file: hasSuffix ".${ext}" file
    && stringLength file > (stringLength ext + 1);
  loader = f;
}
