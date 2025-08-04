{
  description = "A Go project with a modern Nix Flake setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/59e69648d345d6e8fef86158c555730fa12af9de";
  };

  outputs = { self, nixpkgs, ... }:
    let
      # List of systems supported by this flake
      supportedSystems = [ "x86_64-darwin" "x86_64-linux" ];

      # Helper function to generate an attribute set for each system
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Pkgs for each system
      pkgsFor = forAllSystems (system:
        import nixpkgs {
          inherit system;
          overlays = [
            (final: prev: rec {
              go = prev.go_1_24;
              buildGoModule = prev.buildGoModule.override {
                go = go;
              };
            })
          ];
        });
      # Common derivation attributes for the Go module
      goModule = pkgs: {
        pname = "go-cli-test";
        version = "0.1.0";
        src = self;
        vendorHash = "sha256-wBESb9F8Edl2+RXBMXT0SC6n9ww/PJDnVJtUZuKWJ+s=";
        meta = with pkgs.lib; {
          description = "A CLI application built with Go and Cobra";
          homepage = "https://github.com/ritzau/go-cli-test";
          license = licenses.mit;
          maintainers = [ ];
          platforms = platforms.unix;
        };
      };
    in
    {
      # Dev shell for each system
      devShells = forAllSystems (system:
        let pkgs = pkgsFor.${system};
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              delve
              go
              gopls
              go-tools
              gotools
              just
              less
              pre-commit
              ripgrep
              zsh
            ];
          };
        });

      # Packages for each system
      packages = forAllSystems (system:
        let pkgs = pkgsFor.${system};
        in
        {
          default = pkgs.buildGoModule (goModule pkgs);
        });

      # Checks for each system
      checks = forAllSystems (system:
        let pkgs = pkgsFor.${system};
        in
        {
          default = (pkgs.buildGoModule (goModule pkgs)).overrideAttrs (oldAttrs: {
            pname = "${oldAttrs.pname}-tests";
            doCheck = true;
          });
        });
    };
}
