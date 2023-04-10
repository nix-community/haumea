{ haumea }:

let
  inherit (haumea.transformers)
    liftDefault
    hoistAttrs
    ;
in

haumea.load {
  src = ./__fixture;
  transformer = [
    liftDefault
    (hoistAttrs "_api" "options")
  ];
}
