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
    recursiveUpdate
    foldlAttrs
    catAttrs
    concatLists
    ;
in

cursor:

let
  toplevel = cursor == [ ];

  hoistMergeLists = acc: name: value: let

    new =

      if value ? ${from} # eval on value here can cause infinite recursion

      then {
        ${name} = removeAttrs value [ from ];

        # hoist
        ${if toplevel then to else from} = concatLists (
          catAttrs to   [ acc value ] ++
          catAttrs from [ acc value ]
        );
      }

      # merge with initial top level ${to}
      else if name == to && acc ? ${to} then {
        ${name} = acc.${to} ++ value;
      }

      else {
        ${name} = value;
      };

  in recursiveUpdate acc new;

in

foldlAttrs hoistMergeLists {}
