{ pkgs ? import <nixpkgs> {} }:

{
    binaryOverrides = { src, ... } : {
        nativeBuildInputs = with pkgs; [ cmake ];
        buildInputs = with pkgs; [ curl ];
    };
}
