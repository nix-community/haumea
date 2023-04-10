{ lib, super }:

from: to:

# Example from / to
# - Lifting `imports` from: _imports, to: imports
#
# Note:
#   underscore used as mere convention to signalling to the user the "private"
#   nature, they won't be part of the final view presented to the user

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

  # merge attributes shallowly, but concat values of a specific key into a list in that key
  # Type: ((key : String) -> { ... } -> { ... }) -> { ${key} : [ a ], ... }
  mergeAttrsButConcatOn = key: x: y:
    x // y // {
      ${key} = concatLists (catAttrs key [ x y ]);
    };
in

cursor:

let toplevel = cursor == [ ]; in
concatMapAttrsWith (mergeAttrsButConcatOn (if toplevel then to else from))
  (file: value: if ! value ? ${from} then { ${file} = value; } else {
    ${file} = removeAttrs value [ from ];
    # top level ${from} declarations are omitted from merging
    ${if toplevel then to else from} = value.${from};
  })
