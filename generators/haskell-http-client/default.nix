{ pkgs ? import <nixpkgs> {} }:

{
    binaryOverrides = { src, ... } : {
        # We replace `UnspecifiedLicense` with `OtherLicense`, because `UnspecifiedLicense` is not recognized by Cabal2Nix
        src = pkgs.stdenv.mkDerivation {
            name = "haskell-openapi-generated-src-patched";
            inherit src;
            buildPhase = ''
                cp -r $src $out
                cd $out
                # TODO: Why is this needed? It shouldn't be!
                chmod +w .
                sed -i -- 's/UnspecifiedLicense/OtherLicense/g' *.cabal
            '';
           # installPhase = "";
        };
        #nativeBuildInputs = with pkgs; [ cmake ];
        #buildInputs = with pkgs; [ curl ];
    };

    binaryBuilder = { src, ... }: pkgs.haskellPackages.developPackage { root = src; };
    # dontBuildBinaryReason = "TODO";
}
