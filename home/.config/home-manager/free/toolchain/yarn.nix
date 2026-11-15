{ pkgs, ... }:

{
  imports = [ ./node.nix ];

  home.packages = [
    pkgs.yarn
  ];
}
