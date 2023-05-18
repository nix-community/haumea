{
  foo = {
    success = true;
    value."foo.yaml".me = "foo";
  };
  bar = {
    success = true;
    value."bar.yml".me = "bar";
  };
  baz = {
    success = true;
    value.me."me.yaml" = "baz.me";
  };
  rest = {
    success = true;
    value = 42;
  };
}
