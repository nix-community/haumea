{ root }:

let
  inherit (builtins)
    attrNames
    ;
in

assert root.hidden == "hidden";
assert attrNames root.internal == [ "answer" "internal" ];

root.internal.answer
