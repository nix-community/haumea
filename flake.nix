{
  description = "Filesystem-based module system for Nix";

  inputs = {
    nixpkgs.url = "github:nix-community/nixpkgs.lib";
  };

  outputs = { self, nixpkgs }: {
    checks = self.lib.loadEvalTests {
      src = ./tests;
      inputs = {
        inherit (nixpkgs) lib;
        haumea = self.lib;
      };
    };
    lib = import self {
      inherit (nixpkgs) lib;
    };
    templates = {
      default = {
        path = ./templates/default;
        description = "A Nix library";
      };
    };
  };
}
