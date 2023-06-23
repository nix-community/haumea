{ haumea }:

haumea.load {
  src = ./__fixture;
  transformer = haumea.transformers.prependUnderscore;
}
