{
  description = "Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      userConfig = {
        username = builtins.getEnv "USER";
        homeDirectory = builtins.getEnv "HOME";
      };
    in
    {
      homeConfigurations."${userConfig.username}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit userConfig; };
        modules = [ ./home-manager/home.nix ];
      };
    };
}
