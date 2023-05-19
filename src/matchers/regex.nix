_:

let
  inherit (builtins) match;
in

re: f: { match = file: match re file; loader = f; __functor = self: self.loader; }
