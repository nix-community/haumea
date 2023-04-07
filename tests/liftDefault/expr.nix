{ haumea }:

let
  inherit (builtins)
    mapAttrs
    tryEval
    ;

  loaded = haumea.load {
    src = ./__fixture;
    transformer = haumea.transformers.liftDefault;
  };
in

mapAttrs (_: tryEval) loaded
