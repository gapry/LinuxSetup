{ pkgs, userConfig, ... }:

{
  home.username = userConfig.username;
  home.homeDirectory = userConfig.homeDirectory;
  home.stateVersion = "25.11";

  imports = [
    ./node.nix
    ./nvim.nix
    ./zellij.nix
    ./nixpkgs-fmt.nix
    ./osquery.nix
    ./fio.nix
    ./hyperfine.nix
  ];

  programs.home-manager.enable = true;
}
