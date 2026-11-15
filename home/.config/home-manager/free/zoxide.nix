{ pkgs, ... }:

{
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = [
      "--cmd j"
    ];
  };
}
