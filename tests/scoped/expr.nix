{ haumea }:

haumea.load {
  src = ./__fixture;
  loader = haumea.loaders.scoped;
  inputs = {
    answer = 42;
  };
}
