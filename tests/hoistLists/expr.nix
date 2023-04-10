{ haumea }:

let
  inherit (haumea.transformers)
    liftDefault
    hoistLists
    ;
in

haumea.load {
  src = ./__fixture;
  transformer = [
    liftDefault
    (hoistLists "_imports" "imports")
  ];
}
