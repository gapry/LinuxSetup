{ pkgs, ... }:

{
  imports = [ ./docker.nix ];

  home.packages = [
    pkgs.docker-compose
  ];
}
