{ lib, super }:

from: to:

# Example from / to
# - Lifting `options` from: _api, to: options
#
# Note:
#   underscore used as mere convention to signalling to the user the  "private"
#   nature, they won't be part of the final view presented to the user

let
  inherit (builtins)
    removeAttrs
    ;
  inherit (lib)
    recursiveUpdate
    foldlAttrs
    ;
in

cursor:

let

  toplevel = cursor == [ ];

  hoistRecursiveUpdate = acc: name: value: let

    new =

      if value ? ${from} # eval on value here can cause infinite recursion

      then {
        ${name} = removeAttrs value [ from ];

        # hoist
        ${if toplevel then to else from} = {
          ${name} = value.${from};
        };
      }

      else {
        ${name} = value;
      };

  in recursiveUpdate acc new;

in

foldlAttrs hoistRecursiveUpdate {}
