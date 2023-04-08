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
    flip
    getAttrFromPath
    hasSuffix
    id
    nameValuePair
    optionalAttrs
    pipe
    remove
    take
    ;

  parsePath = suffix: path:
    let
      matches = match ''^(_{0,2})(.+)${suffix}$'' path;
    in
    {
      name = elemAt matches 1;
      visibility = {
        "" = "public";
        "_" = "root";
        "__" = "super";
      }.${elemAt matches 0};
    };

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
        if type == "directory" then
          let
            parsed = parsePath "" path;
            inherit (parsed) name visibility;
          in
          nameValuePair name {
            inherit path visibility;
            isDir = true;
            children = aggregate {
              inherit inputs loader;
              src = src + "/${path}";
              tree = tree // {
                pov = tree.pov ++ [ name ];
              };
            };
          }
        else if type == "regular" && hasSuffix ".nix" path then
          let
            parsed = parsePath ''\.nix'' path;
            inherit (parsed) name visibility;
            root = view tree;
          in
          nameValuePair name {
            inherit path visibility;
            isDir = false;
            content = fix (self:
              loader
                (inputs // {
                  inherit root self;
                  super = getAttrFromPath tree.pov root;
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
, transformer ? _: id
}: let
  transformer' =
    if isList transformer
    then (cursor: mod: pipe mod (
      map (t: t cursor) transformer)
    )
    else transformer;
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
      inherit src loader inputs;
      tree = {
        pov = [ ];
        transformer = transformer';
        inherit node;
      };
    };
  });
}
