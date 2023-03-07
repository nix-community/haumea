{ haumea }:

let
  loaded = haumea.load {
    src = ./__fixture;
    loader = haumea.loaders.verbatim;
  };
in

loaded.id 42
