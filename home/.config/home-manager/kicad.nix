{ pkgs, config, ... }:

{
  home.packages = [
    (config.lib.nixGL.wrappers.nvidia pkgs.kicad)
  ];
}
