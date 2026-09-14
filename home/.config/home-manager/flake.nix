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

      pkgs = import nixpkgs {
        inherit system;

        config.allowUnfreePredicate = pkg: nixpkgs.lib.getName pkg == "nvidia";

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
    in
    {
      homeConfigurations."${userConfig.username}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit userConfig nixgl; };
        modules = [ ./home.nix ];
      };
    };
}
