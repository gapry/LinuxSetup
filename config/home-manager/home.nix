{ pkgs, userConfig, config, ... }:

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
    ./postgresql.nix
    ./duckdb.nix
    ./fzf.nix
    ./zoxide.nix
    ./ripgrep.nix
    ./eza.nix
    ./fd.nix
    ./glances.nix
    ./dust.nix
    ./delta.nix
    ./bat.nix
  ];

  programs.home-manager.enable = true;
}
