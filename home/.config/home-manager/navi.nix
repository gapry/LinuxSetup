{ pkgs, ... }:

{
  programs.navi = {
    enable = true;

    enableFishIntegration = true;

    settings = {
      style = {
        tag = {
          color = "cyan";
        };
      };
      cheats = {
        paths = [ "~/.local/share/navi/cheats/" ];
      };
      finder = {
        command = "fzf";
      };
    };
  };
}
