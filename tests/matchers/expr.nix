{ haumea, lib }:

let
  inherit (builtins)
    elemAt
    ;

  inherit (lib)
    importJSON
    ;

  inherit (haumea) matchers;

  # just loads json, after all
  fakeLoadYaml = matches: _: path:
    let
      basename = elemAt matches 0;
      ext = elemAt matches 1;
    in
    {
      "${basename}.${ext}" = importJSON path;
    };
in

haumea.load {
  src = ./__fixture;
  loader = [
    (
      (matchers.regex ''^(.+)\.(yaml|yml)$'' fakeLoadYaml)
      // { __functor = self: (self.loader self.matches); }
    )
    # default loader doesn't consume matches
    (matchers.always haumea.loaders.default)
  ];
}
