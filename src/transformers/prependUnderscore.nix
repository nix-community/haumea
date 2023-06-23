{ lib }:

let
  inherit (builtins)
    substring
    elem
    ;
  inherit (lib)
    mapAttrs'
    stringToCharacters
    nameValuePair
    ;

  start = stringToCharacters "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_";
in

_: mapAttrs' (name: nameValuePair
  (if elem (substring 0 1 name) start then name else "_${name}"))
