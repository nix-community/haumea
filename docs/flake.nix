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
      devShells = eachSystem (pkgs: {
        default = pkgs.mkShell {
          packages = [ pkgs.mdbook ];
          shellHook = ''
            toplevel=$(git rev-parse --show-toplevel) || exit
            cd "$toplevel" || exit
            mkdir -p docs/theme
            ln -sf ${pkgs.documentation-highlighter}/highlight.pack.js docs/theme/highlight.js
            mdbook serve docs
          '';
        };
      });

      packages = eachSystem (pkgs: {
        default = pkgs.stdenv.mkDerivation {
          pname = "haumea-docs";
          version = self.shortRev or "0000000";

          src = ../.;

          nativeBuildInputs = [ pkgs.mdbook ];

          buildPhase = ''
            cd docs
            mkdir theme
            ln -s ${pkgs.documentation-highlighter}/highlight.pack.js theme/highlight.js
            mdbook build -d $out
          '';
        };
      });
    };
}
