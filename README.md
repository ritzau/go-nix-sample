# Go CLI Test

A simple CLI application built with Go, demonstrating:

- 🚀 Go CLI development with Cobra framework
- 🔧 Pre-commit hooks for code quality
- ✅ Comprehensive unit testing
- 📦 Modular package structure
- ❄️ Modern, reproducible Nix builds with Flakes
- 🐳 Ultra-minimal Docker containers (3.79MB!)

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

## Nix Development Environment with Flakes

This project uses **Nix Flakes** for reproducible builds and development environments.

### Project Structure

```
├── flake.nix       # Main entry point for builds, shells, and checks
└── .envrc          # direnv integration for flakes
```

### Quick Start

```bash
# Build the application
nix build

# Run the built binary
./result/bin/go-cli-test --help

# Enter development environment
nix develop

# Or use direnv (if installed)
direnv allow

# Run tests
nix flake check
```

### Key Benefits

- **Reproducible builds**: Same result on any machine with Nix.
- **Pinned dependencies**: The `flake.lock` file ensures consistent package versions.
- **Isolated environment**: No interference with system packages.
- **Hermetic evaluation**: Flakes prevent impurities, ensuring builds are self-contained.

## Flake-based Nix Approach

### `flake.nix` Explained

The `flake.nix` file defines all the outputs of the project:

- **`inputs`**: Pins the version of `nixpkgs` for reproducibility.
- **`outputs`**: A function that produces the project's derivations.
  - **`packages`**: Defines how to build the Go application.
  - **`devShells`**: Defines the development environment with all necessary tools.
  - **`checks`**: Defines how to run the project's tests.

### Development Workflow

1. **Install Nix with Flakes enabled** (if not already installed):
   ```bash
   curl -L https://nixos.org/nix/install | sh
   # Follow instructions to enable flakes
   ```

2. **Clone and enter the project**:
   ```bash
   git clone <repository-url>
   cd go-cli-test
   ```

3. **Enter the development environment**:
   ```bash
   nix-shell
   3. **Enter the development environment**:
   ```bash
   nix develop
   # This automatically provides Go, pre-commit, and all development tools
   ```

4. **Build and run**:
   ```bash
   # Build with Nix
   nix build

   # Run the built binary
   ./result/bin/go-cli-test greet Alice --uppercase

   # Or use direnv for automatic environment loading
   direnv allow
   ```

### Updating Dependencies

To update the pinned nixpkgs version:

1. Find a new commit from: https://github.com/NixOS/nixpkgs/commits/nixos-unstable
2. Update the `url` in `flake.nix` for `nixpkgs`.
3. Update the flake lock file:
   ```bash
   nix flake update
   ```
5. Test: `nix build && nix develop`

## Alternative: Traditional Setup

If you prefer not to use Nix:

### Prerequisites

- Go 1.24 or later
- just
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
   just deps
   ```

3. (Optional) Set up pre-commit hooks:
   ```bash
   # Install pre-commit
   pip install pre-commit
   # Or: brew install pre-commit

   # Setup hooks
   just install-hooks
   ```

## Building and Running

### With Nix (Recommended)
```bash
# Build with Nix
nix build

# Run the built binary
./result/bin/go-cli-test greet Alice

# Or enter development environment first
nix develop
just build && ./go-cli-test greet Alice
```

### Traditional Development
```bash
# Build the application
just build

# Run directly with go
go run main.go greet Alice
```

## Docker Deployment

The project includes Docker support with an ultra-minimal static binary approach:

### Quick Start
```bash
# Build the optimized container (3.79MB!)
docker build -t go-cli-test .

# Run the container
docker run --rm go-cli-test greet "Docker World"
docker run --rm go-cli-test math add 42 58
```

### Docker Features
- **Ultra-minimal size**: Only **3.79MB** final image
- **Maximum security**: Built on `scratch` with static binary (no shell, no packages)
- **Nix-built**: Uses Nix for reproducible, static binary compilation
- **Production-ready**: No runtime dependencies, minimal attack surface

### Using Docker Compose
```bash
# Build and run with docker-compose
docker-compose run --rm go-cli-test greet "Compose"
```

For detailed Docker documentation, see [`DOCKER.md`](./DOCKER.md).

## Testing

```bash
# In development environment (nix develop or with Go installed)
just test                # Run all tests
just test-coverage      # Run tests with coverage
just coverage-report    # Generate HTML coverage report
```

## Code Quality

The project uses pre-commit hooks for code quality:

- **gofmt**: Code formatting
- **go vet**: Static analysis
- **check-yaml/json/toml**: Configuration file validation

Hooks run automatically on commit, or manually:
```bash
just pre-commit
```

## Project Structure

```
go-cli-test/
├── flake.nix               # Main Nix entry point for builds, shells, and checks
├── .envrc                  # direnv integration
├── cmd/                    # CLI commands
├── pkg/                    # Reusable packages
├── main.go                 # Application entry point
├── go.mod                  # Go module definition
├── go.sum                  # Go dependency checksums
├── .gitignore              # Git ignore rules
├── .pre-commit-config.yaml # Pre-commit hooks
├── justfile                # Build automation
├── README.md               # This file
└── DEVELOPMENT.md          # Development setup guide
```

## Examples

```bash
# Build and run with Nix
nix build && ./result/bin/go-cli-test greet

# Basic greeting
./result/bin/go-cli-test greet

# Custom greeting
./result/bin/go-cli-test "John Doe" --prefix "Welcome"

# Math operations
./result/bin/go-cli-test math add 10 20 30
./result/bin/go-cli-test math multiply 2 3 4
./result/bin/go-cli-test math divide 100 5
./result/bin/go-cli-test math sqrt 144
```

## Contributing

1. Enter development environment: `nix develop` (or install Go tools manually)
2. Make your changes
3. Run tests: `just test`
4. Run code quality checks: `just lint`
5. Commit (pre-commit hooks will run automatically)

## Available Just Commands

Run `just --list` to see all available commands.

Key commands:
- `just build` - Build the application
- `just test` - Run tests
- `just fmt` - Format code
- `just lint` - Run linter

## Why Flakes?

This project uses Nix Flakes to demonstrate:
- **Modern Nix features** for better reproducibility and usability.
- **Self-contained package definitions** within the `flake.nix`.
- **Reproducible dependency pinning** with `flake.lock`.
- **Consistent environments** between build and development.

Perfect for learning modern Nix practices!

## License

MIT License
