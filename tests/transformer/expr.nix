{ haumea }:

haumea.load {
  src = ./__fixture;
  transformer = [
    haumea.transformers.liftDefault
    (_: { answer }: answer)
    [
      (_: x: x / 6)
      [
        (_: x: x + 2)
        (_: toString)
      ]
    ]
    (_: x: x + x)
  ];
}
