{ lib, root }:

args:

let
  inherit (builtins)
    attrNames
    ;
  inherit (lib)
    generators
    runTests
    ;

  tests = root.load args;

  results = runTests (tests // {
    tests = attrNames tests;
  });
in

assert tests ? tests
  -> "'tests' cannot be used as the name of a test";

assert results != [ ]
  -> throw (generators.toPretty { } results);

{ }
