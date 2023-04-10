{lib}: let
  inherit (lib)
    attrValues
    flip
    foldl'
    mapAttrs
    pipe
    ;
in {
  /*concatMapAttrsWith: map each attribute in the given set into
    a list of attributes and subsequently merge them into
    a new attribute set with the specified mergeFun.

    Type:
      concatMapAttrsWith :: (AttrSet -> AttrSet -> AttrSet) -> (String -> a -> AttrSet)
        -> AttrSet -> AttrSet

    Example:
      concatMapAttrsWith (mergeAttrsButConcatOn "mykey")
        (name: value: {
          ${name} = value;
          ${key} = value ++ value;
        })
        { x = "a"; y = "b"; }
      => { x = "a"; y = "b"; mykey = [ "aa" "bb"]; }

    */
  concatMapAttrsWith = mergeFun: f: flip pipe [ (mapAttrs f) attrValues (foldl' mergeFun { }) ];
}
