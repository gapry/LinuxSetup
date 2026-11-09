{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
  };

  outputs = { nixpkgs, ... }:
    let
      lib = nixpkgs.lib;

      modulesIn = dir:
        let
          content = builtins.readDir dir;
          names = builtins.attrNames content;
          isModule = name: content.${name} == "regular" && lib.hasSuffix ".nix" name;
        in
        map (name: dir + "/${name}") (builtins.filter isModule names);

      subdirs = dir:
        let
          content = builtins.readDir dir;
          names = builtins.attrNames content;
        in
        map (name: dir + "/${name}") (builtins.filter (name: content.${name} == "directory") names);

      modules = lib.concatMap modulesIn (subdirs ./.);
    in
    {
      nixosConfigurations.linuxsetup = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./configuration.nix ] ++ modules;
      };
    };
}
