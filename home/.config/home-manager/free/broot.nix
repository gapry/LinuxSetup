{ pkgs, ... }:

{
  programs.broot = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      modal = true;
      show_selection_mark = true;

      verbs = [
        {
          invocation = "p";
          execution = ":parent";
        }
        {
          invocation = "edit";
          shortcut = "e";
          execution = "$EDITOR {file}";
        }
        {
          invocation = "view";
          shortcut = "v";
          execution = "less {file}";
        }
      ];

      skin = {
        default = "gray(23) none / gray(20) none";
        tree = "gray(7) none / gray(3) none";
        file = "gray(18) none / gray(15) none";
        directory = "blue bold / blue none";
        exe = "cyan none";
        link = "magenta none";
      };
    };
  };
}
