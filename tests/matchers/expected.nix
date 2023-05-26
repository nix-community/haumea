{
  foo."foo.yaml".me = "foo";
  bar."bar.yml".me = "bar";
  baz = {
    ".nix" = ./__fixture/baz/.nix;
    "foo.yml." = ./__fixture/baz/foo.yml.;
    bar.answer = 42;
    me."me.yaml" = "baz.me";
  };
  rest = 42;
  yaml = ./__fixture/yaml;
}
