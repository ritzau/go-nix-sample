# Go CLI Test

A simple CLI application built with Go, demonstrating:

- 🚀 Go CLI development with Cobra framework
- 🔧 Pre-commit hooks for code quality
- ✅ Comprehensive unit testing
- 📦 Modular package structure
- 🏗️ Traditional Nix packaging and development environment

## Features

### Commands

- **greet**: Greet someone with customizable prefix and formatting
  - `go-cli-test greet Alice` - Basic greeting
  - `go-cli-test greet Alice --uppercase` - Uppercase greeting
  - `go-cli-test greet Alice --prefix "Hi"` - Custom prefix

- **math**: Mathematical operations
  - `go-cli-test math add 1 2 3` - Add numbers
  - `go-cli-test math multiply 2 3 4` - Multiply numbers
  - `go-cli-test math divide 10 2` - Divide numbers
  - `go-cli-test math sqrt 16` - Square root

## Nix Development Environment

This project uses **traditional Nix** (non-flake) for reproducible builds and development environments.

### Project Structure

```
├── default.nix       # Main entry point - builds the package
├── go-cli-test.nix   # Package definition with dependencies
├── shell.nix         # Development environment
├── nixpkgs.nix       # Pinned nixpkgs for reproducibility
└── .envrc           # direnv integration
```

### Quick Start

```bash
# Build the application
nix-build

# Run the built binary
./result/bin/go-cli-test --help

# Enter development environment
nix-shell

# Or use direnv (if installed)
direnv allow
```

### Key Benefits

- **Reproducible builds**: Same result on any machine with Nix
- **Pinned dependencies**: `nixpkgs.nix` ensures consistent package versions
- **Isolated environment**: No interference with system packages
- **Consistent shell and build**: Development uses same Go version as build

## Traditional Nix Approach

### Files Explained

#### `nixpkgs.nix`
Pins nixpkgs to a specific commit for reproducibility:
```nix
# Pin to specific commit - never changes
rev = "057f9aecfb71c4437d2b27d3323df7f93c010b7e";
```

#### `go-cli-test.nix`
Package definition with explicit dependencies:
```nix
{ lib, buildGoModule, fetchFromGitHub }:
# Package definition here
```

#### `default.nix`
Entry point using `callPackage`:
```nix
{ pkgs ? import ./nixpkgs.nix }:
pkgs.callPackage ./go-cli-test.nix { }
```

#### `shell.nix`
Development environment that inherits build dependencies:
```nix
inputsFrom = [ go-cli-test ];  # Same deps as build
buildInputs = [ /* dev tools */ ];
```

### Development Workflow

1. **Install Nix** (if not already installed):
   ```bash
   curl -L https://nixos.org/nix/install | sh
   ```

2. **Clone and enter the project**:
   ```bash
   git clone <repository-url>
   cd go-cli-test
   ```

3. **Enter the development environment**:
   ```bash
   nix-shell
   # This automatically provides Go, pre-commit, and all development tools
   ```

4. **Build and run**:
   ```bash
   # Build with Nix
   nix-build

   # Run the built binary
   ./result/bin/go-cli-test greet Alice --uppercase

   # Or use direnv for automatic environment loading
   direnv allow
   ```

### Updating Dependencies

To update the pinned nixpkgs version:

1. Find a new commit from: https://github.com/NixOS/nixpkgs/commits/nixos-unstable
2. Update the `rev` in `nixpkgs.nix`
3. Get the new hash:
   ```bash
   nix-prefetch-url --unpack https://github.com/NixOS/nixpkgs/archive/NEW_REV.tar.gz
   ```
4. Update the `sha256` in `nixpkgs.nix`
5. Test: `nix-build && nix-shell`

## Alternative: Traditional Setup

If you prefer not to use Nix:

### Prerequisites

- Go 1.22 or later
- pre-commit (optional, for code quality hooks)
- python3 (for pre-commit)

### Getting Started

1. Clone and enter the project:
   ```bash
   git clone <repository-url>
   cd go-cli-test
   ```

2. Install dependencies:
   ```bash
   go mod download
   ```

3. (Optional) Set up pre-commit hooks:
   ```bash
   # Install pre-commit
   pip install pre-commit
   # Or: brew install pre-commit

   # Setup hooks
   make install-hooks
   ```

## Building and Running

### With Nix (Recommended)
```bash
# Build with Nix
nix-build

# Run the built binary
./result/bin/go-cli-test greet Alice

# Or enter development environment first
nix-shell
make build && ./go-cli-test greet Alice
```

### Traditional Development
```bash
# Build the application
make build

# Run directly with go
go run main.go greet Alice
```

## Testing

```bash
# In development environment (nix-shell or with Go installed)
make test                # Run all tests
make test-coverage      # Run tests with coverage
make coverage-report    # Generate HTML coverage report
```

## Code Quality

The project uses pre-commit hooks for code quality:

- **gofmt**: Code formatting
- **go vet**: Static analysis
- **check-yaml/json/toml**: Configuration file validation

Hooks run automatically on commit, or manually:
```bash
make pre-commit
```

## Project Structure

```
go-cli-test/
├── nixpkgs.nix             # Pinned nixpkgs for reproducibility
├── default.nix             # Main Nix entry point
├── go-cli-test.nix         # Package definition
├── shell.nix               # Development environment
├── .envrc                  # direnv integration
├── cmd/                    # CLI commands
├── pkg/                    # Reusable packages
├── main.go                 # Application entry point
├── go.mod                  # Go module definition
├── go.sum                  # Go dependency checksums
├── .gitignore              # Git ignore rules
├── .pre-commit-config.yaml # Pre-commit hooks
├── Makefile                # Build automation
├── README.md               # This file
└── DEVELOPMENT.md          # Development setup guide
```

## Examples

```bash
# Build and run with Nix
nix-build && ./result/bin/go-cli-test greet

# Basic greeting
./result/bin/go-cli-test greet

# Custom greeting
./result/bin/go-cli-test greet "John Doe" --prefix "Welcome"

# Math operations
./result/bin/go-cli-test math add 10 20 30
./result/bin/go-cli-test math multiply 2 3 4
./result/bin/go-cli-test math divide 100 5
./result/bin/go-cli-test math sqrt 144
```

## Contributing

1. Enter development environment: `nix-shell` (or install Go tools manually)
2. Make your changes
3. Run tests: `make test`
4. Run code quality checks: `make lint`
5. Commit (pre-commit hooks will run automatically)

## Available Make Targets

Run `make help` to see all available targets.

Key targets:
- `make build` - Build the application
- `make test` - Run tests
- `make fmt` - Format code
- `make lint` - Run linter

## Why Traditional Nix?

This project uses traditional Nix instead of flakes to demonstrate:
- **Fundamental Nix concepts** without experimental features
- **Modular package structure** using `callPackage`
- **Reproducible dependency pinning** with `nixpkgs.nix`
- **Consistent environments** between build and development

Perfect for learning Nix before moving to more advanced features!

## License

MIT License
