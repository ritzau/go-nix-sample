# Development Guide

Development-specific information for contributors to this Go CLI project.

## Quick Start for Developers

See the main [README.md](README.md) for basic setup instructions.

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

- `make check` - Runs all checks and fixes issues automatically
- `make check-ci` - Runs all checks but fails if issues are found (for CI)
- `make install-hooks` - Installs pre-commit hooks
- `make help` - Shows all available targets

## Testing Guidelines

- All packages should have tests
- Aim for good test coverage
- Run tests before committing: `make test`
- Generate coverage report: `make coverage-report`

## Code Style

- Use `gofmt` for formatting (automated by pre-commit)
- Follow standard Go conventions
- Add comments for exported functions and types
