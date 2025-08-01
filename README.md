# Go CLI Test

A simple CLI application built with Go, demonstrating:

- 🚀 Go CLI development with Cobra framework
- 🔧 Pre-commit hooks for code quality
- ✅ Comprehensive unit testing
- 📦 Modular package structure

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

## Development Setup

### Option 1: Using Nix (Recommended)

The easiest way to get started is with Nix, which provides a complete, reproducible development environment:

1. **Install Nix** (if not already installed):
   ```bash
   curl -L https://nixos.org/nix/install | sh
   # Enable flakes
   echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
   ```

2. **Clone and enter the project**:
   ```bash
   git clone <repository-url>
   cd go-cli-test
   ```

3. **Enter the development environment**:
   ```bash
   nix develop
   # This automatically provides Go, pre-commit, and all development tools
   ```

4. **Build and run**:
   ```bash
   # Build with Nix
   nix build

   # Run directly
   nix run

   # Or run with arguments
   nix run . -- greet Alice --uppercase
   ```

### Option 2: Traditional Setup

If you prefer not to use Nix:

#### Prerequisites

- Go 1.22 or later
- pre-commit (optional, for code quality hooks)
- python3 (for pre-commit)


#### Getting Started

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
   # Using pipx (recommended)
   pipx install pre-commit

   # Or using pip
   pip install pre-commit

   # Or using homebrew (macOS)
   brew install pre-commit

   # Setup hooks
   make install-hooks
   ```

### Building and Running

#### Development
```bash
# Build the application
make build

# Run directly with go
go run main.go greet Alice
```

### Testing

```bash
# Run all tests
make test

# Run tests with coverage
make test-coverage

# Generate HTML coverage report
make coverage-report
```

### Code Quality

The project uses pre-commit hooks for code quality:

- **gofmt**: Code formatting
- **go vet**: Static analysis
- **check-yaml/json/toml**: Configuration file validation

Hooks run automatically on commit, or manually:
```bash
make pre-commit
```

You can also run individual quality checks:
```bash
# Format code
make fmt

# Run linter
make lint
```

## Project Structure

```
go-cli-test/
├── .vscode/                # VS Code workspace configuration
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
# Basic greeting
go-cli-test greet

# Custom greeting
go-cli-test greet "John Doe" --prefix "Welcome"

# Math operations
go-cli-test math add 10 20 30
go-cli-test math multiply 2 3 4
go-cli-test math divide 100 5
go-cli-test math sqrt 144
```

## Contributing

1. Install Go tools and pre-commit hooks as described above
2. Make your changes
3. Run tests (`make test`)
4. Run code quality checks (`make lint`)
5. Commit (pre-commit hooks will run automatically)

## Available Make Targets

Run `make help` to see all available targets.

Key targets:
- `make build` - Build the application
- `make test` - Run tests
- `make fmt` - Format code
- `make lint` - Run linter

## License

MIT License
