{ pkgs, nixgl, ... }:

let
  # nixpkgs 26.05 removed the NVIDIA kernel argument (nix-community/nixGL#223).
  # https://github.com/nix-community/nixGL/pull/223
  patchedNixGL = pkgs.applyPatches {
    name = "nixgl-nvidia-compat";
    src = nixgl;
    patches = [ ./patches/nixgl-nvidia-no-kernel.patch ];
  };
in
{
  targets.genericLinux.nixGL = {
    packages = import patchedNixGL {
      inherit pkgs;
    };

    defaultWrapper = "nvidia";
  };
}
