{ pkgs, ... }: {
  home.packages = [ pkgs.choose ];
}
