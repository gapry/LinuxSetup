{ pkgs, nixgl, ... }:

{
  targets.genericLinux.nixGL = {
    packages = import nixgl {
      inherit pkgs;
    };

    defaultWrapper = "nvidia";
  };
}
