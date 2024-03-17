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

        generateSrcFromOpenApiSpec = { specification, generatorName } :
          pkgs.stdenv.mkDerivation {
            #inherit attrs;

            name = "openapi-generated-source";
            # vesion = "0.1"; # TODO
            nativeBuildInputs = with pkgs; [ openapi-generator-cli ];

            buildPhase = ''
              ${pkgs.openapi-generator-cli}/bin/openapi-generator-cli generate -i ${specification} -g ${generatorName}
            '';

            installPhase = ''
              cp -r . $out
            ''; # TODO change name in src

            dontUnpack = true;
          };

          openapi-generators = {
            "cpp-qt-client" = { specification } :
              rec {
                generated-src = generateSrcFromOpenApiSpec {
                  inherit specification;
                  generatorName = "cpp-qt-client";
                };
                binary = pkgs.stdenv.mkDerivation {
                  name = "cpp-qt-client-openapi-generated";
                  nativeBuildInputs = with pkgs; [ cmake libsForQt5.qtbase libsForQt5.wrapQtAppsHook ];
                  src = "${generated-src}/client";
                };
              };
            "c" = { specification } :
              let
                old_pkgs = (import (builtins.fetchGit {
                    # Descriptive name to make the store path easier to identify
                    name = "nixpkgs-revision-for-curl-7.58.0";
                    url = "https://github.com/NixOS/nixpkgs/";
                    ref = "refs/heads/nixpkgs-unstable";
                    rev = "0b307aa73804bbd7a7172899e59ae0b8c347a62d";
                }) {}).legacyPackages.${system};
              in
              rec {
                generated-src = generateSrcFromOpenApiSpec {
                  inherit specification;
                  generatorName = "c";
                };
                binary = pkgs.stdenv.mkDerivation {
                  name = "c-client-openapi-generated";
                  nativeBuildInputs = with pkgs; [ cmake curl ];
                  src = generated-src;
                };
              };
          };

          ms-graph-specs = {
            "Teams" = pkgs.fetchurl {
              url = "https://raw.githubusercontent.com/microsoftgraph/msgraph-sdk-powershell/dev/openApiDocs/v1.0/Teams.yml";
              sha256 = "sha256-+jEi3MyRrPXW97SFPM/fMQ6D+0AFgcCtOc/ZJlzzV80==";
            };
            "Users" = pkgs.fetchurl {
              url = "https://raw.githubusercontent.com/microsoftgraph/msgraph-sdk-powershell/dev/openApiDocs/v1.0/Users.yml";
              sha256 = "sha256-+jEi3MyRrPXW97SFPM/fMQ6D+0AFgcCtOc/ZJlzzV80==";
            };
          };
      in {

        # nix build
        defaultPackage = (openapi-generators.cpp-qt-client {
          specification = ./problematic_spec.yaml; /*pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/microsoftgraph/msgraph-sdk-powershell/dev/openApiDocs/v1.0/Teams.yml";
            sha256 = "sha256-+jEi3MyRrPXW97SFPM/fMQ6D+0AFgcCtOc/ZJlzzV80==";
            #url = "https://raw.githubusercontent.com/swagger-api/swagger-petstore/master/src/main/resources/openapi.yaml";
            #sha256 = "sha256-C9J+PkNI9HJegqaK/jGL4nj8jb9YdJwdysBMN3AbhIA=";
          };*/
        }).binary;

      }
    );
}
