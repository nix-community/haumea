# transformers/wrapPartsPerSystem.nix
{ ... }:
cursor: mod:
let
  # ===========================================================================
  # LAZY STRUCTURAL MAPPER
  # ===========================================================================
  # This recursively maps over the Haumea tree. Because builtins.mapAttrs
  # is lazy, `lazyWrap child args` becomes a thunk. It will not evaluate
  # until flake-parts explicitly accesses that specific key in the tree.
  lazyWrap =
    node: args:
    let
      # 1. EVALUATE PARTIAL: Only triggered when this specific node is accessed
      resolved = if builtins.isFunction node then node args else node;
    in
    # 2. RECURSE: If it's a standard attrset, lazily map its children.
    # We check for the "derivation" type to prevent infinite recursion into compiled packages.
    if builtins.isAttrs resolved && !(resolved ? type && resolved.type == "derivation") then
      builtins.mapAttrs (_: child: lazyWrap child args) resolved

    # 3. BASE CASE: Return the resolved leaf (package, string, list, etc.)
    else
      resolved;

  # ===========================================================================
  # THE TOP-LEVEL THUNK
  # ===========================================================================
  # We return a single module function to flake-parts.
  # When flake-parts evaluates `perSystem`, it calls this function, injecting { pkgs, system, ... }
  haumeaPartsPerSystemResolverTree =
    {
      pkgs,
      lib,
      system,
      inputs',
      self',
      config,
      ...
    }@perSystemArgs:
    lazyWrap mod perSystemArgs;

in
if cursor == [ "perSystem" ] then
  {
    imports = [ haumeaPartsPerSystemResolverTree ];
  }
else
  mod
