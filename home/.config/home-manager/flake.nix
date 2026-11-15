{
  description = "Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-unstable, nixgl, home-manager, ... }:
    let
      system = "x86_64-linux";
      unfreeDirectory = ./unfree;
      unfreeFiles = nixpkgs.lib.filterAttrs
        (name: type: type == "regular" && nixpkgs.lib.hasSuffix ".nix" name)
        (builtins.readDir unfreeDirectory);
      unfreePackageNames = map
        (name: nixpkgs.lib.removeSuffix ".nix" name)
        (builtins.attrNames unfreeFiles);

      pkgs = import nixpkgs {
        inherit system;

        config.allowUnfreePredicate = pkg:
          let
            packageName = nixpkgs.lib.getName pkg;
          in
          packageName == "nvidia" || builtins.elem packageName unfreePackageNames;

        overlays = [
          (final: prev: {
            unstable = import nixpkgs-unstable { inherit system; };
          })
        ];
      };

      userConfig = {
        username = builtins.getEnv "USER";
        homeDirectory = builtins.getEnv "HOME";
      };

      homeConfiguration = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit userConfig nixgl; };
        modules = [ ./home.nix ];
      };
    in
    {
      packages.${system} = {
        bytehound = pkgs.callPackage ./derivations/bytehound.nix { };
        graphite =
          homeConfiguration.config.lib.nixGL.wrap
            (pkgs.callPackage ./derivations/graphite.nix { });
      };

      homeConfigurations."${userConfig.username}" = homeConfiguration;
    };
}
