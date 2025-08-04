# Build stage using Nix
FROM nixos/nix:latest AS builder

# Enable flakes and the nix command
RUN echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf

# Set working directory
WORKDIR /app

# Copy the entire project (needed for flake)
COPY . .

# Build the application using Nix (static build)
RUN nix build .#static --out-link result

# Extract the binary from the Nix store
RUN cp result/bin/go-cli-test main

# Final stage: minimal runtime
FROM scratch

# Copy the static binary from builder stage
COPY --from=builder /app/main /go-cli-test

# Set the entrypoint to the binary
ENTRYPOINT ["/go-cli-test"]

# Default command (can be overridden)
CMD ["--help"]
