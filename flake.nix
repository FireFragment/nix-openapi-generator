{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
  }:
    {
      overlay = import ./overlay.nix;
    }
    // flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        lib = (import ./default.nix) {
          inherit pkgs;
        };

        packages.testing = (import ./testing_package.nix) {
            inherit pkgs;
        };
      }
    );
}
