{
  description = "Filesystem-based module system for Nix";

  inputs = {
    nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";
  };

  outputs = { self, nixpkgs-lib }: {
    checks = self.lib.loadEvalTests {
      src = ./tests;
      inputs = {
        inherit (nixpkgs-lib) lib;
        haumea = self.lib;
      };
    };
    lib = import self {
      inherit (nixpkgs-lib) lib;
    };
    templates = {
      default = {
        path = ./templates/default;
        description = "A Nix library";
      };
    };
  };
}
