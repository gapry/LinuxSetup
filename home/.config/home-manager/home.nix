{ userConfig, lib, ... }:

{
  home.username = userConfig.username;
  home.homeDirectory = userConfig.homeDirectory;
  home.stateVersion = "25.11";

  imports =
    let
      modulesIn = directory:
        let
          content = builtins.readDir directory;
          modules = builtins.filter
            (name: lib.hasSuffix ".nix" name && content.${name} == "regular")
            (builtins.attrNames content);
        in
        map (name: directory + "/${name}") modules;
    in
    [ ./home-manager.nix ./nix.nix ./nixgl.nix ] ++
    modulesIn (./. + "/free") ++
    modulesIn (./. + "/unfree");

  targets.genericLinux.enable = !builtins.pathExists /etc/NIXOS;
}
