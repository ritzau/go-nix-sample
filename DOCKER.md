# Docker Setup for go-cli-test

This directory contains Docker configuration files to run the Go CLI application in a container.

## Files Created

- `Dockerfile` - Multi-stage Docker build configuration
- `.dockerignore` - Excludes unnecessary files from build context
- `docker-build.sh` - Helper script to build the Docker image
- `docker-compose.yml` - Docker Compose configuration for easier management

## Building the Docker Image

### Option 1: Using the helper script
```bash
./docker-build.sh
```

### Option 2: Manual build
```bash
docker build -t go-cli-test .
```

## Running the Container

### Show help (default command)
```bash
docker run --rm go-cli-test
```

### Run specific commands
```bash
# Greet someone
docker run --rm go-cli-test greet World

# Greet with uppercase
docker run --rm go-cli-test greet --uppercase World

# Greet with custom prefix
docker run --rm go-cli-test greet --prefix="Hi there" World

# Math operations
docker run --rm go-cli-test math add 5 3
docker run --rm go-cli-test math subtract 10 4
docker run --rm go-cli-test math multiply 6 7
docker run --rm go-cli-test math divide 15 3
```

### Interactive shell (for debugging)
```bash
# Note: Current static binary image (scratch) has no shell
# For debugging, use the Alpine variant or inspect with:
docker run --rm --entrypoint "" go-cli-test-static ls -la / 2>/dev/null || echo "No shell available"

# To build Alpine variant for debugging:
# docker build -f Dockerfile.alpine -t go-cli-test-alpine .
# docker run --rm -it go-cli-test-alpine /bin/sh
```

## Using Docker Compose

### Build and run
```bash
# Build the image
docker-compose build

# Run with default command
docker-compose run --rm go-cli-test

# Run with specific command
docker-compose run --rm go-cli-test greet Docker
```

## Container Details

- **Base Image**: Scratch (empty image)
- **Binary**: Static binary built with Nix
- **Security**: Maximum security (no shell, no packages, no attack surface)
- **Size**: **3.79MB** (ultra-minimal)
- **Dependencies**: None (statically linked)

## Image Variants

We provide three different Docker image approaches:

### 1. Static Binary with Scratch (Current/Recommended)
- **Image size**: **3.79MB**
- **Base**: `scratch` (empty image) with static binary
- **Use case**: Production deployments, minimal attack surface
- **Pros**:
  - Absolute minimal size
  - No runtime dependencies
  - Maximum security (no shell, no packages)
  - Built with Nix for reproducibility
- **Cons**: No shell for debugging (by design)

### 2. Alpine-based (Alternative)
- **Image size**: ~18.6MB
- **Base**: Alpine Linux with Go runtime
- **Use case**: Good balance of size and functionality
- **Pros**: Small size, familiar Linux environment, shell access
- **Cons**: Larger than static, includes unnecessary runtime dependencies

### 3. Nix-based with Debian (Development)
- **Image size**: ~100MB+
- **Base**: Debian with Nix-built binary
- **Use case**: Development and debugging
- **Pros**: Full Linux environment, consistent with development build process
- **Cons**: Large size due to glibc and runtime dependencies

The current `Dockerfile` uses the **static binary approach** for optimal production deployment.

## Image Features

- Multi-stage build for smaller final image
- Security hardened (non-root user)
- Includes CA certificates for HTTPS requests
- Statically compiled binary for portability
- Optimized build context with `.dockerignore`

## Environment Variables

The container can be customized with environment variables if needed (currently none are used by the CLI application).

## Volumes

If your CLI application needs to read/write files, you can mount volumes:

```bash
docker run --rm -v $(pwd)/data:/app/data go-cli-test
```

## Troubleshooting

### Build Issues
- Ensure Docker is running
- Check that all source files are present
- Verify network connectivity for downloading Go modules

### Runtime Issues
- The static binary image has no shell for debugging (by design for security)
- For troubleshooting, check container exit codes and error messages
- Use `docker build -f Dockerfile.alpine` to create a debuggable version if needed
- Verify command syntax with `docker run --rm go-cli-test --help`
