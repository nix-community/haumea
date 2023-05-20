_:

let
  inherit (builtins) match;
in

re: f:

{
  matches = file: match re file != null;
  loader = inputs: path:
    f (match re (baseNameOf path)) inputs path;
}
