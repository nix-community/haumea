{ lib, root }:

let
  inherit (builtins)
    all
    attrValues
    elemAt
    foldl'
    isList
    length
    mapAttrs
    match
    readDir
    ;
  inherit (lib)
    concatMapAttrs
    fix
    flatten
    flip
    getAttrFromPath
    nameValuePair
    optionalAttrs
    pipe
    remove
    take
    ;

  parsePath = path: type:
    let
      matches =
        if type == "directory"
        then match ''^(_{0,2})(.+)$'' path
        else if type == "regular"
        then match ''^(_{0,2})(.+)\.[^.]+$'' path
        else throw "unreachable";
    in
    {
      name = elemAt matches 1;
      visibility = {
        "" = "public";
        "_" = "root";
        "__" = "super";
      }.${elemAt matches 0};
    };

  matchPathToLoaders = loaders: inputs: path:
    let
      file = baseNameOf path;
      m = matched: next:
        let
          matches = next.match file;
        in
        if matched != null
        then matched
        else if matches != null
        then (next // { inherit matches; }) inputs path
        else null;
    in
    foldl' m null loaders;

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

  aggregate = { src, loader, inputs, tree }:
    let
      aggregateEntry = path: type:
        let
          parsed = parsePath path type;
          inherit (parsed) name visibility;

          children = aggregate {
            inherit inputs loader;
            src = src + "/${path}";
            tree = tree // {
              pov = tree.pov ++ [ name ];
            };
          };

          root = view tree;
          content = fix (self:
            loader
              (inputs // {
                inherit root self;
                super = getAttrFromPath tree.pov root;
              })
              (src + "/${path}")
          );
        in
        if type == "directory" then
          nameValuePair name
            {
              inherit path visibility children;
              isDir = true;
            }
        else if type == "regular" then
          nameValuePair name
            {
              inherit path visibility content;
              isDir = false;
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
              haumea failed when traversing ${src}
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
  loader' =
    if isList loader
    then matchPathToLoaders loader
    else matchPathToLoaders [ (root.matchers.nixFiles loader) ];
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
      loader = loader';
      tree = {
        pov = [ ];
        transformer = transformer';
        inherit node;
      };
    };
  });
}
