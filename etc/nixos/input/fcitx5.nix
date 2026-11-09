{ pkgs, ... }:

{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = [
      pkgs.fcitx5-rime
      pkgs.qt6Packages.fcitx5-configtool
    ];
  };
}
