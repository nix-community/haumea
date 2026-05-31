# loaders/dispatch.nix
#
# Accepts a list of policies — each an attrset pairing a match predicate with an action:
#
#   runIf  : bool | (ctx -> bool)    match predicate;   default: true  (always match)
#   runFn  : inputs -> path -> a     loader thunk to invoke;  default: loaders.scoped
#   logIf  : bool | (ctx -> bool)    enable tracing;    default: false
#   logPfx : string                  trace prefix;      default: "[dispatch]"
#   logSfx : string                  trace suffix note; default: ""n
#
# ctx is: { path, inputs }
# Policies are evaluated in order — first match wins, action is invoked.
# The action (runFn) is never called until its policy is selected.

{ lib, ... }@fnArgs:
policies:
let
  default = {
    # if no runIf condition is provided, default to match. This helps minimize boilerplate.
    runIf = true;
    runFn = fnArgs.loaders.scoped;
    logIf = false;
    logFn = builtins.trace;
    logPfx = "[L] :dispatch:\t";
    logSep = " ";
    logFmt =
      ctx:
      [
        "${ctx.logPfx}"
        "path=${ctx.path}"
        "runIf=${if ctx.runIf then "true" else "false"}"
        "type=${builtins.typeOf ctx.result}"
      ]
      ++ (if ctx.logSfx != "" then [ "\t -- ${ctx.logSfx}" ] else [ ]);
    logSfx = "";
  };
  evalPred =
    pred: ctx:
    if builtins.isBool pred then
      pred
    else if builtins.isFunction pred then
      (pred ctx) == true
    else
      false;

  firstMatch =
    ctx: remaining:
    if remaining == [ ] then
      builtins.throw "${default.logPfx} disjoint policies - no policy match found for path '${ctx.path}'"
    else
      let
        policy = builtins.head remaining;
      in
      if evalPred (policy.runIf or default.runIf) ctx then
        policy
      else
        firstMatch ctx (builtins.tail remaining);
in
inputs: path:
let
  ctx = {
    inherit
      policy
      path
      inputs
      result
      runIf
      runFn
      logIf
      logFn
      logPfx
      logSfx
      logSep
      logFmt
      ;
  };
  # Limit the info available during firstMatch to prevent infinite recursion.
  matchCtx = { inherit path inputs; };
  policy = firstMatch matchCtx policies;
  result = runFn inputs path;
  runIf = evalPred (if policy ? runIf then policy.runIf else default.runIf) ctx; # render runIf to bool
  logIf = evalPred (
    if policy ? logIf then
      policy.logIf
    else if default ? logIf then
      default.logIf
    else
      policy.runIf
  ) ctx; # render logIf to bool, default: trace only on runIf
  runFn = policy.runFn or default.runFn or (throw "${logPfx} no loader (or default loader) provided");
  logFn = policy.logFn or default.logFn;
  logPfx = policy.logPfx or default.logPfx;
  logSfx = policy.logSfx or default.logSfx;
  logSep = policy.logSep or default.logSep;
  logFmt = policy.logFmt or default.logFmt;
  logMsg = builtins.concatStringsSep logSep (logFmt ctx);
in
if logIf then logFn logMsg result else result
