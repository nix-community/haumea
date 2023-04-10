{ lib, super }: from: to:

# Example from / to
# - Lifting `imports` from: _imports, to: imports
#
# Note: underscore used as mere convention to
#       signalling to the user the  "private"
#       nature, they won't be part of the final
#       view presented to the user

let
  inherit (builtins)
    removeAttrs
    ;

  inherit (lib)
    catAttrs
    concatLists
    ;

  inherit (super.utils)
    concatMapAttrsWith
    ;

  /*mergeAttrsButConcatOn: merge attributes shallowly, but
    concat values of a specific key into a list in that key

    Type:
      (key :: String -> AttrSet -> AttrSet) -> { ${key} :: List; ... }

    */
  mergeAttrsButConcatOn = key: x: y:
    x // y // {
      ${key} = concatLists (catAttrs key [ x y ]);
    };

in
cursor:
if cursor == [ ] # toplevel
then
  concatMapAttrsWith (mergeAttrsButConcatOn to)
    (file: value: if ! value ? ${from} then { ${file} = value; } else {
      ${file} = removeAttrs value [ from ];
      # top level ${from} declarations are omitted from merging
      ${to} = value.${from};
    })
else
  concatMapAttrsWith (mergeAttrsButConcatOn from)
    (file: value: if ! value ? ${from} then { ${file} = value; } else {
      ${file} = removeAttrs value [ from ];
      ${from} = value.${from};
    })
