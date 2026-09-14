{ pkgs, ... }:

{
  imports = [ ./node.nix ];

  home.packages = [
    pkgs.pnpm
  ];
}
