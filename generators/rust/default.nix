{ pkgs ? import <nixpkgs> {} }:

{
    dontBuildBinaryReason = ''
        Rust libraries are almost always built from source by the user - Rust libraries are not often obtained as binaries.
        You should use the generated source instead.
    '';
    /*binaryOverrides = { src, ... } : {
        nativeBuildInputs = with pkgs; [ pkg-config ];
        buildInputs = with pkgs; [ openssl ];
        #src = "${src}/client";
        cargoSha256 = "sha256-sHBIalZTEv/zy6Y8E1FOoDrj2G+uRRaUH3kgSSqOVRE=";
    };
    binaryBuilder = pkgs.rustPlatform.buildRustPackage;
    */

    srcOverrides = { buildPhase ? "", ... } : {
        buildPhase = "
            ${buildPhase}
            cp ${pkgs.writeText "cargo-lock-for-openapi-rust" ((import ./Cargo.lock.nix) {})} ./Cargo.lock";
    };
}
