{ lib
, buildGoModule
}:

buildGoModule rec {
  pname = "go-cli-test";
  version = "0.1.0";

  # Use Git to determine what files to include, then filter to only Go-related files
  # This automatically excludes anything in .gitignore AND only includes Go source files
  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.intersection
      (lib.fileset.gitTracked ./.)
      (lib.fileset.unions [
        # Go module files
        ./go.mod
        ./go.sum

        # All Go source files (including tests)
        (lib.fileset.fileFilter (file: file.hasExt "go") ./.)
      ]);
  };

  # You'll need to update this vendorHash when dependencies change
  # Run `nix-build` and it will tell you the correct hash if this is wrong
  vendorHash = "sha256-wBESb9F8Edl2+RXBMXT0SC6n9ww/PJDnVJtUZuKWJ+s=";

  # Disable tests during build (you can run them separately)
  doCheck = false;

  meta = with lib; {
    description = "A CLI application built with Go and Cobra";
    homepage = "https://github.com/ritzau/go-cli-test";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
