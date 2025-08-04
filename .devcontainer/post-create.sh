#!/bin/bash
set -e

# This script is executed after the container is created.

echo "Running post-create script..."

# Update package lists and install direnv
sudo apt-get update && sudo apt-get install -y direnv

# Allow direnv to load the environment for the workspace
direnv allow .

# Add direnv hook to shell configuration files
echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc

echo "Post-create script finished."
