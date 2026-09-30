# transformers/liftDefaultPartsPerSystem.nix
{ ... }:
cursor: mod:
if builtins.isAttrs mod && mod ? default then
  let
    siblings = builtins.removeAttrs mod [ "default" ];
    hoisted = mod.default;
  in
  if siblings == { } then
    hoisted
  else
  # If the hoisted default is a deferred function (from scopedPartial),
  # we must defer the merge until flake-parts provides the args.
  if builtins.isFunction hoisted then
    args: siblings // (hoisted args)
  else
    siblings // hoisted
else
  mod
