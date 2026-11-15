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
          names = builtins.attrNames content;
          modules = builtins.filter
            (name: lib.hasSuffix ".nix" name && content.${name} == "regular")
            names;
          directories = builtins.filter
            (name: content.${name} == "directory")
            names;
        in
        map (name: directory + "/${name}") modules ++
        builtins.concatLists
          (map (name: modulesIn (directory + "/${name}")) directories);
    in
    [ ./home-manager.nix ./nix.nix ./nixgl.nix ] ++
    modulesIn (./. + "/free") ++
    modulesIn (./. + "/unfree");

  targets.genericLinux.enable = !builtins.pathExists /etc/NIXOS;
}
