{
  options = {
    root = "option";
    bar = {
      baz = {
        qui = "option";
        xoo = {
          xoo = "option";
        };
      };
      tul = "option";
    };
  };
  foo = "foo";
  bar.baz = {
    qux = "qux";
    xoo = {
      xoo = true;
    };
  };
}
