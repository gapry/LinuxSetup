{
  description = "Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;

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
        extraSpecialArgs = { inherit userConfig; };
        modules = [ ./home.nix ];
      };
    };
}
