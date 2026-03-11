{ pkgs, userConfig, ... }:

{
  home.username = userConfig.username;
  home.homeDirectory = userConfig.homeDirectory;
  home.stateVersion = "25.11";

  imports = [
    ./node.nix
  ];

  programs.home-manager.enable = true;
}
