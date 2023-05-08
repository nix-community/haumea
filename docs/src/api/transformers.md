# Transformers

## `transformers.hoistAttrs`

Source: [`src/transformers/hoistAttrs.nix`](https://github.com/nix-community/haumea/blob/main/src/transformers/hoistAttrs.nix)

Type: `(from : String) -> (to : String) -> [ String ] -> { ... } -> { ... }`

This transformer will hoist any attribute of type Attrs with key
`${from}` up the chain. When the root node is reached, it will
be renamed to an attribute of type Attrs with key `${to}` and
as such presented back to the consumer.

Neighbouring lists are concatenated (`recursiveUpdate`) during hoisting.
Root doesn't concat `${from}` declarations, use `${to}` at the root.

This can be used to declare `options` locally at the leaves
of the configuration tree, where the NixOS module system would
not otherwise tolerate them.

## `transformers.hoistLists`

Source: [`src/transformers/hoistLists.nix`](https://github.com/nix-community/haumea/blob/main/src/transformers/hoistLists.nix)

Type: `(from : String) -> (to : String) -> [ String ] -> { ... } -> { ... }`

This transformer will hoist any attribute of type List with key
`${from}` up the chain. When the root node is reached, it will
be renamed to an attribute of type List with key `${to}` and
as such presented back to the consumer.

Neighbouring lists are concatenated (`++`) during hoisting.
Root doesn't concat `${from}` declarations, use `${to}` at
the root.

This can be used to declare `imports` locally at the leaves
of the configuration tree, where the NixOS module system would
not otherwise tolerate them.

## `transformers.liftDefault`

Source: [`src/transformers/liftDefault.nix`](https://github.com/nix-community/haumea/blob/main/src/transformers/liftDefault.nix)

Type: `[ String ] -> { ... } -> { ... }`

This transformer will lift the contents of `default` into the module.
It will fail if `default` is not an attribute set,
or has any overlapping attributes with the module.
