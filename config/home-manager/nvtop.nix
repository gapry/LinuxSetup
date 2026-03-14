{ pkgs, ... }:

let
  unfreePkgs = import pkgs.path {
    inherit (pkgs.stdenv.hostPlatform) system;
    config.allowUnfree = true;
  };
in
{
  home.packages = [
    unfreePkgs.nvtopPackages.nvidia
  ];
}
