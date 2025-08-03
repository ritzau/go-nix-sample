# Pinned nixpkgs for reproducible builds
# This pins to a specific commit that never changes

let
  # Choose a specific commit from: https://status.nixos.org/
  rev = "59e69648d345d6e8fef86158c555730fa12af9de";

  nixpkgs = fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
    # Get this by running: nix-prefetch-url --unpack <url>
    sha256 = "1yai46329qflr2q96if28dcf3ppgjbyp269hmfa2wkj3f03rfa12";
  };
in
import nixpkgs {
  overlays = [
    (final: prev: rec {
      go = prev.go_1_24;
      buildGoModule = prev.buildGoModule.override {
        go = go;
      };
    })
  ];
}
