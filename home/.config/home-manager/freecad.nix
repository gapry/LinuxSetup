{ pkgs, config, nixgl, ... }:

{
  targets.genericLinux.nixGL.packages = import nixgl {
    inherit pkgs;
  };

  home.packages = [
    (config.lib.nixGL.wrappers.nvidia pkgs.freecad)
  ];
}
