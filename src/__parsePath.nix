{ lib }:

let
  inherit (builtins)
    filter
    genList
    stringLength
    substring
    tail
    ;
  inherit (lib)
    hasPrefix
    hasSuffix
    id
    pipe
    last
    removePrefix
    ;
in

path: type:

let
  stripped = removePrefix "_" (removePrefix "_" path);
in

if stripped == "" then
  null
else {
  inherit stripped;

  name = {
    directory = stripped;

    regular =
      let
        dots = pipe stripped [
          stringLength
          (genList id)
          tail
          (filter (i: substring i 1 stripped == "."))
        ];
      in
      if hasSuffix "." stripped || dots == [ ] then
        stripped
      else
        substring 0 (last dots) stripped;
  }.${type};

  visibility =
    if hasPrefix "__" path then
      "super"
    else if hasPrefix "_" path then
      "root"
    else
      "public";
}
