{
  description = "aiql";

  inputs = {
    nixpkgs      = { url = "github:NixOS/nixpkgs/nixpkgs-unstable"; };
    flake-utils  = { url = "github:numtide/flake-utils"; };
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
  };

  outputs = { self, nixpkgs, flake-compat, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        name = "aiql";
        ghc-version = "ghc98";
        pkgs = nixpkgs.legacyPackages.${system};
        hskg = pkgs.haskell.packages.${ghc-version}; # "make update" first sometimes helps
        revision = "${self.lastModifiedDate}-${self.shortRev or "dirty"}";
      in rec {
        # nix develop
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            cacert
            git
            gmp
            hskg.cabal-install
            hskg.ghc
            hskg.hlint
            sourceHighlight
            watchexec
            zlib.dev
          ];
          nativeInputs = [];
          nativeBuildInputs = [];          
          
          shellHook = ''
            export SHELL=$BASH
            export LANG=en_US.UTF-8
            export PS1="aiql|$PS1"
          '';

        };
        devShell = self.devShells.${system}.default;
      }
    );
}
