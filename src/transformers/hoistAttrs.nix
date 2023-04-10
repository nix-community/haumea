{ lib, super }:

from: to:

# Example from / to
# - Lifting `options` from: _api, to: options
#
# Note:
#   underscore used as mere convention to signalling to the user the  "private"
#   nature, they won't be part of the final view presented to the user

let
  inherit (lib)
    recursiveUpdate
    ;
  inherit (super.utils)
    concatMapAttrsWith
    ;
in

cursor:

let toplevel = cursor == [ ]; in
concatMapAttrsWith recursiveUpdate
  (file: value: if ! value ? ${from} then { ${file} = value; } else {
    ${file} = removeAttrs value [ from ];
    # top level ${from} declarations are omitted from merging
    ${if toplevel then to else from} = { ${file} = value.${from}; };
  })

