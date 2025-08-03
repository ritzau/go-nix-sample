# Pinned nixpkgs for reproducible builds
# This pins to a specific commit that never changes

let
  # Choose a specific commit from: https://github.com/NixOS/nixpkgs/commits/nixos-unstable
  # Or use a release: https://github.com/NixOS/nixpkgs/releases
  rev = "59e69648d345d6e8fef86158c555730fa12af9de"; # Example: known good commit

  nixpkgs = fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
    # Get this by running: nix-prefetch-url --unpack <url>
    sha256 = "1yai46329qflr2q96if28dcf3ppgjbyp269hmfa2wkj3f03rfa12";
  };
in
import nixpkgs { }
