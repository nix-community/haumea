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

importer:

inputs: path:

let
  f = toFunction (importer path);
in

pipe f [
  functionArgs
  (mapAttrs (name: _: inputs.${name}))
  f
]
