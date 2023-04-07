{ lib }:

let
  inherit (lib.attrsets)
    unionOfDisjoint
    ;
in

mod:

unionOfDisjoint
  (removeAttrs mod [ "default" ])
  (mod.default or { })
