{ pkgs, config, nixgl, ... }:

{
  home.packages = [
    (config.lib.nixGL.wrap pkgs.freecad)
  ];
}
