# OpenAPI generator for Nix

This Nix library allows you to incorporate generation of client/server libraries from OpenAPI specification to your build process using [OpenAPI generator](https://openapi-generator.tech/)

## Examples

### Building the library

For some generators such as `c` or `cpp-qt-client`, this flake allows you to compile a binary library:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    openapi-generator.url = "..";
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
    openapi-generator
  }:
    {
      overlay = import ./overlay.nix;
    }
    // flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        openapi-gen = openapi-generator.lib.${system};

        # Use the "cpp-qt-client" generator
        generated = (openapi-gen.getGenerator "cpp-qt-client") {
          specification = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/OAI/OpenAPI-Specification/9df68a1dafd467d9fdbf68653f351b860b4ec6e5/examples/v3.0/petstore.yaml";
            sha256 = "sha256-WYE2y5BOF+ju6tUa4z3Y1AH9/0VdLXTzhpxKpfJ0ImY=";
          };
        };
      in {
        packages.default = generated.binary;
      }
    );
}
```

It can also generate source code using any generator listed on the [OpenAPI generator webpage](https://openapi-generator.tech/docs/generators):

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    openapi-generator.url = "..";
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
    openapi-generator
  }:
    {
      overlay = import ./overlay.nix;
    }
    // flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        openapi-gen = openapi-generator.lib.${system};

        # Use the "cpp-qt-client" generator
        generated = (openapi-gen.getGenerator "cpp-qt-client") {
          specification = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/OAI/OpenAPI-Specification/9df68a1dafd467d9fdbf68653f351b860b4ec6e5/examples/v3.0/petstore.yaml";
            sha256 = "sha256-WYE2y5BOF+ju6tUa4z3Y1AH9/0VdLXTzhpxKpfJ0ImY=";
          };
        };
      in {
        packages.default = generated.sourceCode;
      }
    );
}
```
