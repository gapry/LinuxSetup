{ pkgs, ... }:

{
  home.packages = with pkgs; [
    docker_29
  ];
}
