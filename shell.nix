{ pkgs ? import ./nixpkgs.nix }:

let
  # Import our package to get the same Go version and dependencies
  go-cli-test = pkgs.callPackage ./go-cli-test.nix {};
in

pkgs.mkShell {
  # Include the package's build dependencies
  inputsFrom = [ go-cli-test ];

  # Add development-specific tools
  buildInputs = with pkgs; [
    # Development tools not needed for build
    gopls         # Go language server
    gotools       # Additional Go tools (goimports, etc.)
    go-tools      # Static analysis tools (staticcheck, etc.)
    delve         # Go debugger

    # Development utilities
    git
    gnumake
    which
    coreutils

    # Code quality tools
    pre-commit
    gofumpt
    golangci-lint
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
    echo "  nix-build        - Build with Nix"
    echo "  ./result/bin/go-cli-test - Run the built binary"
    echo ""

    # Set up Go environment in project directory
    export GOPATH="$PWD/.go"
    export GOCACHE="$PWD/.cache/go-build"
    export GOMODCACHE="$PWD/.cache/go-mod"

    # Create directories if they don't exist
    mkdir -p .go .cache/go-build .cache/go-mod

    # Install pre-commit hooks if not already installed
    if [ -d .git ] && [ ! -f .git/hooks/pre-commit ]; then
      echo "Installing pre-commit hooks..."
      make install-hooks 2>/dev/null || echo "Run 'make install-hooks' to set up pre-commit hooks"
    fi
  '';
}
