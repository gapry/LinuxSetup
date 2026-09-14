{ pkgs, config, ... }:

{
  imports = [ ./nixgl.nix ];

  home.packages = [
    (config.lib.nixGL.wrap pkgs.gnuradio)
  ];
}
