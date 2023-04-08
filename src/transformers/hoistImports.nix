{ lib }:

let
  inherit (builtins)
    attrValues
    length
    mapAttrs
    removeAttrs
    isAttrs
    catAttrs
    filter
    ;
  inherit (lib)
    flatten
    optionalAttrs
    ;

in

cursor: mod: let
  toplevel = length cursor == 0;
  # peek forward one level down if it is an attrs
  leafattrs = filter isAttrs (attrValues mod);
  # and collect '_imports' keys where they exists
  # into a flat list of imports
  _imports = flatten (catAttrs "_imports" leafattrs);
  # then remove those just so collected andthereby
  # complete the "hoist"
  mod' = mapAttrs (_: v:
    if v ? _imports
    then removeAttrs v ["_imports"]
    else v
  ) mod;
in mod'
# attach the hoisted imports to the current level
# and if we've reached tho toplevel rename to 'imports'
# which the module system can understand
// optionalAttrs (_imports != [] && toplevel) {imports = _imports;}
// optionalAttrs (_imports != [] && !toplevel) {inherit _imports;}
