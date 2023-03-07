{ haumea }:

let
  inherit (builtins)
    tryEval
    ;
in

tryEval (haumea.load {
  src = ./__fixture;
})
