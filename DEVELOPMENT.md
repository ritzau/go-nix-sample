# Development Guide

Development-specific information for contributors to this Go CLI project.

## Quick Start for Developers

See the main [README.md](README.md) for basic setup instructions.

### Option 1: Using Nix (Recommended)

If you have Nix installed with flakes enabled:

```bash
# Enter the development environment
nix develop

# Or use direnv for automatic environment loading
direnv allow  # (if .envrc exists)

# Build with Nix
nix build

# Run with Nix
nix run
```

### Option 2: Traditional Go Development

Ensure you have Go 1.21+ installed, then follow the instructions in README.md.

## Pre-commit Hook Details

The pre-commit hooks run automatically on `git commit` and include:

- **trailing-whitespace**: Remove trailing whitespace
- **end-of-file-fixer**: Ensure files end with newline
- **check-yaml/json**: Validate configuration files
- **go-fmt**: Format Go code with `gofmt`
- **go-vet**: Run Go static analysis
- **go-mod-tidy**: Clean up go.mod and go.sum

### Skipping Hooks

To skip pre-commit hooks for a specific commit:
```bash
git commit --no-verify -m "commit message"
```

## Make Target Details

### Standard Targets
- `make check` - Runs all checks and fixes issues automatically
- `make check-ci` - Runs all checks but fails if issues are found (for CI)
- `make install-hooks` - Installs pre-commit hooks
- `make help` - Shows all available targets

### Nix-specific Targets
- `make nix-build` - Build the project using Nix
- `make nix-run` - Run the application using Nix
- `make nix-shell` - Enter the Nix development shell
- `make nix-update-hash` - Update vendorHash when Go dependencies change

## Testing Guidelines

- All packages should have tests
- Aim for good test coverage
- Run tests before committing: `make test`
- Generate coverage report: `make coverage-report`

## Code Style

- Use `gofmt` for formatting (automated by pre-commit)
- Follow standard Go conventions
- Add comments for exported functions and types

## Nix Development Environment

### First-time Setup

1. **Install Nix** (if not already installed):
   ```bash
   # On macOS/Linux
   curl -L https://nixos.org/nix/install | sh

   # Enable flakes (required)
   echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
   ```

2. **Enable direnv** (optional but recommended):
   ```bash
   # Install direnv
   nix profile install nixpkgs#direnv

   # Add to your shell profile (.zshrc, .bashrc, etc.)
   eval "$(direnv hook zsh)"  # or bash, fish, etc.
   ```

3. **Enter the development environment**:
   ```bash
   # Manual activation
   nix develop

   # Or with direnv (automatic)
   direnv allow
   ```

### Working with Dependencies

When you add or update Go dependencies:

1. Update `go.mod` as usual:
   ```bash
   go get github.com/some/package
   go mod tidy
   ```

2. Update the Nix vendorHash:
   ```bash
   make nix-update-hash
   ```

### Building and Running

```bash
# Build with Nix (creates ./result symlink)
nix build

# Run directly with Nix
nix run

# Run with arguments
nix run . -- greet --help

# Traditional Go build (in nix shell)
make build
./go-cli-test
```

### Advantages of the Nix Setup

- **Reproducible**: Everyone gets exactly the same development environment
- **Isolated**: No conflicts with system-installed tools
- **Complete**: Includes Go, formatters, linters, and all development tools
- **Cached**: Build artifacts are cached and shared across machines
- **Cross-platform**: Works identically on macOS, Linux, and NixOS
