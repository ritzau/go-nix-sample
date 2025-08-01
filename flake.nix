{
  description = "Go CLI application with Nix development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Package definition for the Go CLI
        go-cli-test = pkgs.buildGoModule {
          pname = "go-cli-test";
          version = "0.1.0";

          src = ./.;

          vendorHash = "sha256-wBESb9F8Edl2+RXBMXT0SC6n9ww/PJDnVJtUZuKWJ+s=";

          meta = with pkgs.lib; {
            description = "A CLI application built with Go and Cobra";
            homepage = "https://github.com/ritzau/go-cli-test";
            license = licenses.mit;
            maintainers = [ ];
          };
        };

      in {
        # Default package
        packages.default = go-cli-test;
        packages.go-cli-test = go-cli-test;

        # Development shell
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Go toolchain
            go
            gopls
            gotools
            go-tools
            delve  # Go debugger

            # Development tools
            git
            gnumake

            # Pre-commit hooks
            pre-commit

            # Testing and coverage tools
            gofumpt
            golangci-lint

            # Optional: for better shell experience
            direnv
          ];

          shellHook = ''
            echo "🚀 Go development environment loaded!"
            echo "Go version: $(go version)"
            echo ""
            echo "Available commands:"
            echo "  make build       - Build the binary"
            echo "  make test        - Run tests"
            echo "  make check       - Run all checks"
            echo "  nix build        - Build with Nix"
            echo "  nix run          - Run the application with Nix"
            echo ""

            # Set up Go environment
            export GOPATH="$PWD/.go"
            export GOCACHE="$PWD/.cache/go-build"
            export GOMODCACHE="$PWD/.cache/go-mod"

            # Create directories if they don't exist
            mkdir -p .go .cache/go-build .cache/go-mod

            # Install pre-commit hooks if not already installed
            if [ ! -f .git/hooks/pre-commit ]; then
              echo "Installing pre-commit hooks..."
              make install-hooks 2>/dev/null || echo "Run 'make install-hooks' to set up pre-commit hooks"
            fi
          '';
        };

        # NixOS module (optional, for system-wide installation)
        nixosModules.default = { config, lib, pkgs, ... }:
          with lib;
          {
            options.services.go-cli-test = {
              enable = mkEnableOption "go-cli-test service";
            };

            config = mkIf config.services.go-cli-test.enable {
              environment.systemPackages = [ go-cli-test ];
            };
          };

        # Apps for `nix run`
        apps.default = flake-utils.lib.mkApp {
          drv = go-cli-test;
        };
      });
}
