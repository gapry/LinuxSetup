{ pkgs, userConfig, ... }:

{
  home.packages = [
    pkgs.nodejs_24
  ];

  home.sessionVariables = {
    NODE_PATH = "${userConfig.homeDirectory}/.nix-profile/lib/node_modules";
  };
}
