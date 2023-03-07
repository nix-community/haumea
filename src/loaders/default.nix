{ lib }:

let
  inherit (builtins)
    mapAttrs
    ;
  inherit (lib)
    functionArgs
    pipe
    toFunction
    ;
in

inputs: path:

let
  f = toFunction (import path);
in

pipe f [
  functionArgs
  (mapAttrs (name: _: inputs.${name}))
  f
]
