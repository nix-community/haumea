# transformers/match.nix
# Note:
# - the predicate (abbrv. "logIf") allows shipping a function or boolean value into the execution context.
# - If 'logIf' evals true, the trace log will emit. If not it will proceed normally, but without emitting a trace event.
# - The default value of 'logIf' is boolean false.
# - Using 'logIf' and 'logSfx' should allow for emitting simple trace messages only when certain watched conditions are encountered in the execution context.
# - If used (carefully), a custom 'logFmt' can also get supplemental diagnostic info from the execution context.
# - To perform only tracing, use the trace transformer instead of this.
{ super, ... }@fnArgs:
ctx: innerFunc: cursor: mod:
let
  fullCtx =
    fnArgs
    // ctx
    // {
      inherit
        innerFunc
        cursor
        mod
        typeOf
        runIf
        logIf
        ;
    };
  default = {
    runIf = true;
    logIf = false;
    logPfx = "[T] :match:\t";
  };
  simplify = part: ctx: if builtins.isFunction part then (part ctx) else part;
  evalPred = pred: ctx: (simplify pred ctx) == true;
  ##
  typeOf = builtins.typeOf mod;
  runIf = evalPred (if ctx ? runIf then ctx.runIf else default.runIf) fullCtx; # render runIf to bool
  logIf = evalPred (
    if ctx ? logIf then
      ctx.logIf
    else if default ? logIf then
      default.logIf
    else
      runIf
  ) ctx; # render logIf to bool, default: trace only on runIf
  logFn = data: super.trace fullCtx cursor data;
  logFnBefore = logFn mod;
  logFnAfter = logFn result;
  result = innerFunc cursor mod;
in
if logIf && runIf then
  logFnAfter
else if runIf then
  result
else
  logFnBefore
