{ super }:

let
  inherit (super) regex;
in

regex ''^(.+)\.nix$''
