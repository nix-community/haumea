{
  inputs = {
    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
    };
    nixpkgs-lib.url = "github:nix-community/nixpkgs.url";
  };

  outputs = { self, haumea, nixpkgs-lib }: {
    checks = haumea.lib.loadEvalTests {
      src = ./tests;
      inputs = {
        inherit (nixpkgs-lib) lib;
        foo = self.lib;
      };
    };
    lib = haumea.lib.load {
      src = ./src;
      inputs = {
        inherit (nixpkgs-lib) lib;
      };
    };
  };
}
