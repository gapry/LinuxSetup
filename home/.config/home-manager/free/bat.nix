{ pkgs, ... }:

{
  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      style = "numbers,changes,header";
      italic-text = "always";
    };
  };
}
