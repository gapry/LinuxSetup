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
    ./tig.nix
    ./doggo.nix
    ./xh.nix
    ./jnv.nix
    ./choose.nix
    ./tldr.nix
    ./procs.nix
    ./duf.nix
    ./ncdu.nix
    ./yazi.nix
    ./fastfetch.nix
    ./lstopo.nix
    ./inxi.nix
    ./docker.nix
    ./pcstat.nix
  ];

  programs.home-manager.enable = true;
}
