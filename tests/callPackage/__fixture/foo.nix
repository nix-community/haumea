{ lib, value ? "foo" }:

lib.id {
  inherit value;
}
