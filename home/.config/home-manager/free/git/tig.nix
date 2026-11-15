{ pkgs, ... }:

{
  home.packages = [
    pkgs.tig
  ];

  home.file.".tigrc".text = ''
    set vertical-split = false
    set line-graphics = utf-8
    color cursor white red bold
  '';
}
