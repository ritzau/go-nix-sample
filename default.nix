{ pkgs ? import ./nixpkgs.nix }:

pkgs.callPackage ./go-cli-test.nix { }
