TARGET_BINARY=go-cli-test

# Build the binary
.PHONY: build
build:
	go build -o $(TARGET_BINARY) .

# Run tests
.PHONY: test
test:
	go test -v ./...

# Run tests with coverage
.PHONY: test-coverage
test-coverage:
	go test -cover ./...

# Generate coverage report
.PHONY: coverage-report
coverage-report:
	go test -coverprofile=coverage.out ./...
	go tool cover -html=coverage.out -o coverage.html
	@echo "Coverage report generated: coverage.html"

# Run basic Go checks
.PHONY: lint
lint:
	go vet ./...

# Format code
.PHONY: fmt
fmt:
	gofmt -w .

# Run all checks (same as pre-commit hooks, useful for CI)
.PHONY: check
check:
	@echo "=== Running all checks ==="
	@echo "1. Formatting Go code..."
	gofmt -w .
	@echo "2. Running go vet..."
	go vet ./...
	@echo "3. Tidying Go modules..."
	go mod tidy
	@echo "✅ All checks passed!"

# Run checks without fixing (for CI)
.PHONY: check-ci
check-ci:
	@echo "=== Running CI checks ==="
	@echo "1. Checking Go formatting..."
	@test -z "$$(gofmt -l .)" || (echo "Go files not formatted. Run 'make fmt'" && exit 1)
	@echo "2. Running go vet..."
	go vet ./...
	@echo "3. Checking Go modules..."
	go mod tidy && git diff --exit-code go.mod go.sum
	@echo "✅ All CI checks passed!"

# Clean build artifacts
.PHONY: clean
clean:
	rm -f $(TARGET_BINARY)
	rm -f coverage.out coverage.html

# Install dependencies
.PHONY: deps
deps:
	go mod download
	go mod tidy

# Run pre-commit hooks
.PHONY: pre-commit
pre-commit:
	pre-commit run --all-files

# Install pre-commit hooks
.PHONY: install-hooks
install-hooks:
	pre-commit install --install-hooks

# Run the application with sample commands
.PHONY: demo
demo: build
	@echo "=== Demo: Basic greeting ==="
	./$(TARGET_BINARY) greet
	@echo ""
	@echo "=== Demo: Custom greeting ==="
	./$(TARGET_BINARY) greet Alice --prefix "Hi"
	@echo ""
	@echo "=== Demo: Uppercase greeting ==="
	./$(TARGET_BINARY) greet "John Doe" --uppercase
	@echo ""
	@echo "=== Demo: Math operations ==="
	./$(TARGET_BINARY) math add 10 20 30
	./$(TARGET_BINARY) math multiply 2 3 4
	./$(TARGET_BINARY) math divide 100 5
	./$(TARGET_BINARY) math sqrt 144

# Check development environment
.PHONY: check-env
check-env:
	@echo "=== Development Environment Check ==="
	@echo "Go version: $$(go version 2>/dev/null || echo 'Go not found')"
	@echo "Go location: $$(which go 2>/dev/null || echo 'Go not found')"
	@echo "Available tools:"
	@printf "  gofmt: %s\n" "$$(which gofmt 2>/dev/null || echo 'not found')"
	@printf "  goimports: %s\n" "$$(which goimports 2>/dev/null || echo 'not found')"
	@printf "  goimports: %s\n" "$$(which goimports 2>/dev/null || echo 'not found')"
	@printf "  pre-commit: %s\n" "$$(which pre-commit 2>/dev/null || echo 'not found')"

# Help
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  build          Build the binary"
	@echo "  test           Run tests"
	@echo "  test-coverage  Run tests with coverage"
	@echo "  coverage-report Generate HTML coverage report"
	@echo "  lint           Run linter"
	@echo "  fmt            Format code"
	@echo "  check          Run all checks (fixes issues)"
	@echo "  check-ci       Run all checks (fails on issues)"
	@echo "  clean          Clean build artifacts"
	@echo "  deps           Install/update dependencies"
	@echo "  pre-commit     Run pre-commit hooks"
	@echo "  install-hooks  Install pre-commit hooks"
	@echo "  demo           Build and run demo commands"
	@echo "  check-env      Check development environment"
	@echo "  help           Show this help"
