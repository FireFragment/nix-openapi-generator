{ pkgs ? import <nixpkgs> {} }:

let
    lib = (import ./default.nix) { inherit pkgs; };
    testingSpec = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/marscod/ollama/f8b0324477469562bab5e6b352c8d6e2759533ac/api/ollama_api_specification.json";
        sha256 = "sha256-hsSLRHgcVGV3G0fmOQ+ZNkD3FH7lDXNaTvQHXTRz624=z";
    };
    testingSpec2 = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/examples/v3.0/petstore.yaml";
        sha256 = "sha256-WYE2y5BOF+ju6tUa4z3Y1AH9/0VdLXTzhpxKpfJ0ImY=";
    };

    createCommandForAttr =
        generator-name: generator:
            let
                generated = generator { specification = testingSpec; };
            in
            builtins.concatStringsSep "\n" [
                ''
                    echo "Symlinking OpenAPI generated library: ${generator-name}"
                    ln -s ${generated.generated-src} $out/sources/${generator-name}
                ''
                (
                    if generated.dontBuildBinaryReason == null then ''
                        ln -s ${generated.binary} $out/binaries/${generator-name}
                    ''
                    else ''
                        ln -s ${pkgs.writeText "nix-openapi-generator-test-${generator-name}-unsupported-binary.txt" generated.dontBuildBinaryReason} $out/binaries/${generator-name}-not-supported.txt
                        echo "${generator-name} doesn't support building a binary. Reason: ${generated.dontBuildBinaryReason}"
                    ''
                )
            ];
    commands = builtins.mapAttrs createCommandForAttr lib.generators;
    buildScript = builtins.concatStringsSep "\n" (builtins.attrValues commands);
in

pkgs.stdenv.mkDerivation {
    name = "nix-openapi-generator-test";
    dontUnpack = true;
    buildPhase = ''
        mkdir -p $out/binaries/
        mkdir -p $out/sources/
        ${buildScript}
    '';
}
