{ pkgs ? import <nixpkgs> {} }:

{
    binaryOverrides = { src, ... } : {
        nativeBuildInputs = with pkgs; [ cmake libsForQt5.wrapQtAppsHook ];
        buildInputs = with pkgs; [ libsForQt5.qtbase ];
        src = "${src}/client";
    };
}
