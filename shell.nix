let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-unstable";
  pkgs = import nixpkgs { config = {}; overlays = []; };
  artcraft-flake = (builtins.getFlake "github:Hy4ri/artcraft-flake").packages.x86_64-linux;
in

pkgs.mkShellNoCC {
  packages = with pkgs; [
    godot
    artcraft-flake.vectorcraft
  ];
}
