#!/bin/bash

# Build the Docker image
echo "Building Docker image..."
docker build -t go-cli-test .

if [ $? -eq 0 ]; then
    echo "✅ Docker image built successfully!"
    echo ""
    echo "To run the container:"
    echo "  docker run --rm go-cli-test"
    echo "  docker run --rm go-cli-test greet --name=World"
    echo "  docker run --rm go-cli-test math add 5 3"
    echo ""
    echo "To run interactively:"
    echo "  docker run --rm -it go-cli-test /bin/sh"
else
    echo "❌ Docker build failed!"
    exit 1
fi
