{ pkgs, userConfig, config, lib, ... }:

{
  home.username = userConfig.username;
  home.homeDirectory = userConfig.homeDirectory;
  home.stateVersion = "25.11";

  imports =
    let
      content = builtins.readDir ./.;
      files = builtins.attrNames content;
      isModule = name:
        name != "home.nix" &&
        name != "flake.nix" &&
        lib.hasSuffix ".nix" name &&
        content.${name} == "regular";
    in
    map (name: ./. + "/${name}") (builtins.filter isModule files);

  targets.genericLinux.enable = true;

  nix = {
    package = pkgs.nix;

    enable = true;

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
  };

  programs.home-manager.enable = true;
}
