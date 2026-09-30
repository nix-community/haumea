# loaders/scopedPartsPerSystem.nix
{ ... }:
inputs: path: newCtx:
let
  imported = builtins.scopedImport (inputs // newCtx) path;
in
if builtins.isFunction imported then imported newCtx else imported
