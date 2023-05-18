_:

let
  inherit (builtins) match;
in

re: f: { matches = file: match re file; loader = f; }
