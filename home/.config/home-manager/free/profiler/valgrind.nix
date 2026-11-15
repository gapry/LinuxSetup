{ pkgs, ... }:

{
  home.packages = [
    pkgs.valgrind
  ];
}
