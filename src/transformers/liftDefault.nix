{ lib }:

let
  inherit (lib.attrsets)
    unionOfDisjoint
    ;
in

_: mod:

unionOfDisjoint
  (removeAttrs mod [ "default" ])
  (mod.default or { })
