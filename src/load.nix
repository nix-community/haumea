{ lib, root }:

let
  inherit (builtins)
    all
    attrValues
    filter
    foldl'
    head
    length
    mapAttrs
    readDir
    ;
  inherit (lib)
    concatMapAttrs
    fix
    flatten
    flip
    getAttrFromPath
    isFunction
    nameValuePair
    optionalAttrs
    pipe
    remove
    take
    ;

  entry = { isDir, path, ... }:
    "${if isDir then "directory" else "file"} '${path}'";

  view = { cursor ? [ ], node, pov, transformer }:
    if node.isDir then
      transformer cursor
        (flip concatMapAttrs node.children
          (name: node: optionalAttrs
            {
              public = true;
              root = pov != "external";
              super = pov != "external" && take (length cursor) pov == cursor;
            }.${node.visibility}
            {
              ${name} = view {
                cursor = cursor ++ [ name ];
                inherit node pov transformer;
              };
            }))
    else
      node.content;

  aggregate = { src, matchers, inputs, tree }:
    let
      aggregateEntry = path: type:
        let
          parsed = root.parsePath path type;
          inherit (parsed) name visibility stripped;
          matches = filter (m: m.matches stripped) matchers;
        in
        if parsed == null then
          null
        else if type == "directory" then
          nameValuePair name
            {
              inherit path visibility;
              isDir = true;
              children = aggregate {
                inherit inputs matchers;
                src = src + "/${path}";
                tree = tree // {
                  pov = tree.pov ++ [ name ];
                };
              };
            }
        else if type == "regular" && matches != [ ] then
          nameValuePair name
            {
              inherit path visibility;
              isDir = false;
              content = fix (self:
                (head matches).loader
                  (inputs // {
                    inherit self;
                    super = getAttrFromPath tree.pov (view tree);
                    root = view tree;
                  })
                  (src + "/${path}"));
            }
        else
          null;
    in
    pipe src [
      readDir
      (mapAttrs aggregateEntry)
      attrValues
      (remove null)
      (flip foldl' { }
        (acc: { name, value }:
          if acc ? ${name} then
            throw ''
              haumea failed when traversing ${toString src}
              - ${entry acc.${name}} conflicts with ${entry value}
            ''
          else
            acc // {
              ${name} = value;
            }))
    ];
in

{ src
, loader ? root.loaders.default
, inputs ? { }
, transformer ? [ ]
}:

let
  transformer' = cursor: flip pipe
    (map (t: t cursor) (flatten transformer));
in

assert all
  (name: inputs ? ${name}
    -> throw "'${name}' cannot be used as the name of an input")
  [ "self" "super" "root" ];

view {
  pov = "external";
  transformer = transformer';
  node = fix (node: {
    isDir = true;
    children = aggregate {
      inherit src inputs;
      matchers =
        if isFunction loader then
          [ (root.matchers.nix loader) ]
        else
          loader;
      tree = {
        pov = [ ];
        transformer = transformer';
        inherit node;
      };
    };
  });
}
