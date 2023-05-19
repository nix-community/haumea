{ haumea }:

let
  inherit (builtins)
    elemAt
    fromJSON
    mapAttrs
    readFile
    tryEval
    ;

  inherit (haumea) matchers;

  # just loads json, after all
  fakeLoadYaml = matches: _: path:

    let
      basename = elemAt matches 0;
      ext = elemAt matches 1;
    in

    {
      "${basename}.${ext}" = fromJSON (readFile path);
    };

  loaded = haumea.load {
    src = ./__fixture;
    loader = [
      (
        (matchers.regex ''^(.+)\.(yaml|yml)$'' fakeLoadYaml)
        // { __functor = self: (self.loader self.matches);}
      )
      # default loader doesn't consume matches
      (matchers.always haumea.loaders.default)
    ];
  };
in

mapAttrs (_: tryEval) loaded
