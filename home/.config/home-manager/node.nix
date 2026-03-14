{ pkgs, userConfig, ... }:

{
  home.packages = [
    pkgs.nodejs_24
    pkgs.nodePackages.pnpm
    pkgs.nodePackages.yarn
  ];

  home.sessionVariables = {
    NODE_PATH = "${userConfig.homeDirectory}/.nix-profile/lib/node_modules";
  };
}
