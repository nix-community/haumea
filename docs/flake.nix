{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      inherit (nixpkgs.lib)
        genAttrs
        ;

      eachSystem = f: genAttrs
        [
          "aarch64-darwin"
          "aarch64-linux"
          "x86_64-darwin"
          "x86_64-linux"
        ]
        (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = eachSystem (pkgs: {
        default = pkgs.stdenv.mkDerivation {
          pname = "haumea-docs";
          version = self.shortRev or "0000000";

          src = ../. + "/docs";

          nativeBuildInputs = [ pkgs.mdbook ];

          buildPhase = ''
            mkdir theme
            ln -s ${pkgs.documentation-highlighter}/highlight.pack.js theme/highlight.js
            mdbook build -d $out
          '';
        };
      });
    };
}
