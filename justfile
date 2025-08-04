# Variables
TARGET_BINARY := "go-cli-test"

# Build the binary
build:
    go build -o {{TARGET_BINARY}} .

# Run tests
test:
    go test -v ./...

# Run tests with coverage
test-coverage:
    go test -cover ./...

# Generate coverage report
coverage-report:
    go test -coverprofile=coverage.out ./...
    go tool cover -html=coverage.out -o coverage.html
    @echo "Coverage report generated: coverage.html"

# Run basic Go checks
lint:
    go vet ./...

# Format code
fmt:
    git ls-files '*.go' | xargs gofmt -w

# Run all checks (same as pre-commit hooks, useful for CI)
check:
    @echo "=== Running all checks ==="
    @echo "1. Formatting Go code..."
    just fmt
    @echo "2. Running go vet..."
    just lint
    @echo "3. Tidying Go modules..."
    go mod tidy
    @echo "✅ All checks passed!"

# Run checks without fixing (for CI)
check-ci:
    @echo "=== Running CI checks ==="
    @echo "1. Checking Go formatting..."
    @test -z "$(git ls-files '*.go' | xargs gofmt -l)" || (echo "Go files not formatted. Run 'just fmt'" && exit 1)
    @echo "2. Running go vet..."
    just lint
    @echo "3. Checking Go modules..."
    go mod tidy && git diff --exit-code go.mod go.sum
    @echo "✅ All CI checks passed!"

# Clean build artifacts
clean:
    rm -f {{TARGET_BINARY}}
    rm -f coverage.out coverage.html

# Install dependencies
deps:
    go mod download
    go mod tidy

# Run pre-commit hooks
pre-commit:
    pre-commit run --all-files

# Install pre-commit hooks
install-hooks:
    pre-commit install --install-hooks

# Run the application with sample commands
demo: build
    @echo "=== Demo: Basic greeting ==="
    ./{{TARGET_BINARY}} greet
    @echo ""
    @echo "=== Demo: Custom greeting ==="
    ./{{TARGET_BINARY}} greet Alice --prefix "Hi"
    @echo ""
    @echo "=== Demo: Uppercase greeting ==="
    ./{{TARGET_BINARY}} greet "John Doe" --uppercase
    @echo ""
    @echo "=== Demo: Math operations ==="
    ./{{TARGET_BINARY}} math add 10 20 30
    ./{{TARGET_BINARY}} math multiply 2 3 4
    ./{{TARGET_BINARY}} math divide 100 5
    ./{{TARGET_BINARY}} math sqrt 144

# Check development environment
check-env:
    @echo "Checking environment..."
    @echo "Go version:"
    @go version
    @echo "Just version:"
    @just --version

# Nix-specific targets

# Build with Nix
nix-build:
    nix build

# Enter Nix development shell
nix-shell:
    nix shell

# Build pure Nix container (works best on Linux, limited on macOS)
nix-container:
    @echo "🔨 Building pure Nix container..."
    @echo "💡 Note: Cross-compilation macOS→Linux not supported by Nix"
    @echo "🐧 This works great in Linux environments (Ubuntu, CI, etc.)"
    nix build .#container
    @echo "✅ Nix container built: result"
    @echo "📦 This creates a Docker-compatible tarball"

# Build Nix layered container with better caching
nix-container-layered:
    @echo "🔨 Building Nix layered container..."
    @echo "🐧 Works best in Linux environments"
    nix build .#container-layered
    @echo "✅ Nix layered container built: result"

# Load Nix container into Docker and test
nix-docker-test: nix-container
    @echo "📦 Loading Nix container into Docker..."
    @echo "🐧 Note: Only works properly in Linux environments"
    docker load < result
    @echo "🧪 Testing Nix-built container..."
    @echo "1. Help command:"
    docker run --rm go-cli-test-nix:latest --help
    @echo ""
    @echo "2. Greet command:"
    docker run --rm go-cli-test-nix:latest greet "Nix" --uppercase
    @echo ""
    @echo "3. Math command:"
    docker run --rm go-cli-test-nix:latest math multiply 6 7
    @echo ""
    @echo "✅ Nix container tests passed!"

# Docker targets

# Build Docker image (static binary with scratch base - 3.79MB)
docker-build:
    @echo "🐳 Building ultra-minimal Docker image..."
    docker build -t go-cli-test .
    @echo "✅ Docker image built successfully!"
    @echo "📏 Image size:"
    @docker images go-cli-test:latest --format "table {{{{.Repository}}}}\t{{{{.Tag}}}}\t{{{{.Size}}}}"
    @echo ""
    @echo "🚀 To run the container:"
    @echo "  docker run --rm go-cli-test"
    @echo "  docker run --rm go-cli-test greet World"
    @echo "  docker run --rm go-cli-test math add 5 3"

# Build Docker image with custom tag
docker-build-tag TAG:
    @echo "🐳 Building Docker image with tag: {{TAG}}..."
    docker build -t {{TAG}} .
    @echo "✅ Docker image built successfully as {{TAG}}"

# Test Docker container with various commands
docker-test: docker-build
    @echo "🧪 Testing Docker container..."
    @echo "1. Help command:"
    docker run --rm go-cli-test --help
    @echo ""
    @echo "2. Greet command:"
    docker run --rm go-cli-test greet "Docker" --uppercase
    @echo ""
    @echo "3. Math command:"
    docker run --rm go-cli-test math add 42 58
    @echo ""
    @echo "✅ All Docker tests passed!"

# Clean Docker images
docker-clean:
    @echo "🧹 Cleaning Docker images..."
    docker rmi go-cli-test:latest || true
    docker rmi go-cli-test-static:latest || true
    docker rmi go-cli-test-nix:latest || true
    @echo "✅ Docker images cleaned"

# Show Docker image sizes for comparison
docker-sizes:
    @echo "📊 Docker image size comparison:"
    @docker images | grep go-cli-test | sort -k1,1 | awk '{printf "  %-25s %-10s %s\n", $1, $2, $7}'

# Show all available container build options
container-help:
    @echo "🐳 Container Build Options:"
    @echo ""
    @echo "📦 Production (Linux containers):"
    @echo "  just docker-build      → 3.79MB ultra-minimal (Dockerfile + Nix + scratch)"
    @echo "  just docker-test       → Build + comprehensive testing"
    @echo ""
    @echo "🔨 Development (Nix-native):"
    @echo "  just nix-container     → Pure Nix container (Linux environments)"
    @echo "  just nix-docker-test   → Nix container + Docker testing"
    @echo ""
    @echo "📏 Size comparison:"
    @echo "  just docker-sizes      → Compare all built images"
    @echo ""
    @echo "💡 Recommendation:"
    @echo "  • macOS development: Use 'just docker-build' for production containers"
    @echo "  • Linux development: Use either approach, Nix containers are faster"
    @echo "  • CI/Production: Use 'just docker-build' for maximum compatibility"
