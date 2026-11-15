{ userConfig, lib, ... }:

{
  home.username = userConfig.username;
  home.homeDirectory = userConfig.homeDirectory;
  home.stateVersion = "25.11";

  imports =
    let
      content = builtins.readDir ./.;
      files = builtins.attrNames content;
      unfreeDirectory = ./. + "/unfree";
      unfreeContent = builtins.readDir unfreeDirectory;
      unfreeModules = builtins.filter
        (name: lib.hasSuffix ".nix" name && unfreeContent.${name} == "regular")
        (builtins.attrNames unfreeContent);
      isModule = name:
        name != "home.nix" &&
        name != "flake.nix" &&
        lib.hasSuffix ".nix" name &&
        content.${name} == "regular";
    in
    map (name: ./. + "/${name}") (builtins.filter isModule files) ++
    map (name: unfreeDirectory + "/${name}") unfreeModules;

  targets.genericLinux.enable = !builtins.pathExists /etc/NIXOS;
}
