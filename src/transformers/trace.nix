# transformers/trace.nix
# Note:
# - the predicate (abbrv. "logIf") allows shipping a function or boolean value into the execution context.
# - If 'logIf' evals true, the trace log will emit. If not it will proceed normally, but without emitting a trace event.
# - The default value of 'logIf' is boolean true.
# - Using 'logIf' and 'logSfx' should allow for emitting trace messages only when certain watched conditions are true within the execution context.
# - If used (carefully), a custom 'logFmt' can also get supplemental diagnostic info from the execution context.
# - To perform a conditional transform, use the match transformer instead of this.
{ ... }@fnArgs:
ctx: cursor: mod:
let
  fullCtx =
    fnArgs
    // ctx
    // {
      inherit
        cursor
        mod
        typeOf
        keys
        runIf
        logIf
        logPfx
        logSep
        logSfx
        logFmt
        ;
    };
  default = {
    logIf = true;
    logPfx = "[T] :trace:\t";
    logSep = " ";
    logFmt =
      ctx:
      [
        "${ctx.logPfx}"
        "cursor=${builtins.toJSON ctx.cursor}"
        "runIf=${builtins.toJSON ctx.runIf}"
        "type=${ctx.typeOf}"
      ]
      ++ (if builtins.isString ctx.logSfx && ctx.logSfx != "" then [ "\t-- ${ctx.logSfx}" ] else [ ]);
    logSfx = "";
  };
  simplify = part: ctx: if builtins.isFunction part then (part ctx) else part;
  evalPred = pred: ctx: (simplify pred ctx) == true;
  ##
  typeOf = builtins.typeOf mod;
  keys = if builtins.isAttrs mod then builtins.toJSON (builtins.attrNames mod) else "N/A";
  ##
  runIf = if ctx ? runIf then ctx.runIf else null;
  logIf = evalPred (
    if ctx ? logIf then
      ctx.logIf
    else if default ? logIf then
      default.logIf
    else
      runIf
  ) fullCtx;
  logPfx = if ctx ? logPfx then ctx.logPfx else default.logPfx;
  logSep = if ctx ? logSep then ctx.logSep else default.logSep;
  logSfx = if ctx ? logSfx then ctx.logSfx else default.logSfx;
  logFmt = simplify (if ctx ? logFmt then ctx.logFmt else default.logFmt) fullCtx;
  logMsg = builtins.concatStringsSep logSep logFmt;
in
if logIf then builtins.trace logMsg mod else mod
