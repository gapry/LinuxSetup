{ pkgs, ... }:

let
  ghc = pkgs.haskellPackages.ghcWithPackages (hp: [
    hp.xmonad
    hp.xmonad-contrib
    hp.xmonad-extras
  ]);
in
{
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
    };
  };

  services.displayManager.defaultSession = "none+xmonad";

  environment.systemPackages = [
    ghc
    pkgs.xmobar
    pkgs.dmenu
    pkgs.rofi
    pkgs.trayer
    pkgs.i3lock
    pkgs.xorg-server
    pkgs.libx11
    pkgs.libxft
    pkgs.libxinerama
    pkgs.libxrandr
    pkgs.libxscrnsaver
  ];
}
