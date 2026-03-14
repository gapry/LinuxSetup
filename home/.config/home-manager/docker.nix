{ pkgs, ... }:

{
  home.packages = with pkgs; [
    docker
    docker-compose
    ctop
    lazydocker
  ];
}
