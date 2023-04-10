{ lib }:

# map each attribute in the given set into
# a list of attributes and subsequently merge them into
# a new attribute set with the specified mergeFun.

# Type: ({ ... } -> { ... } -> { ... }) -> (String -> a -> { ... }) -> { ... } -> { ... }

# Example:
#   concatMapAttrsWith (mergeAttrsButConcatOn "mykey")
#     (name: value: {
#       ${name} = value;
#       ${key} = value ++ value;
#     })
#     { x = "a"; y = "b"; }
#   => { x = "a"; y = "b"; mykey = [ "aa" "bb"]; }

let
  inherit (builtins)
    attrValues
    foldl'
    mapAttrs
    ;
  inherit (lib)
    flip
    pipe
    ;
in

merge: f: flip pipe [ (mapAttrs f) attrValues (foldl' merge { }) ]
