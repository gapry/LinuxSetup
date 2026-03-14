{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;

    enableFishIntegration = true;

    settings = {
      mgr = {
        show_hidden = true;
        sort_by = "mtime";
        sort_reverse = true;
      };

      opener = {
        edit = [
          { run = ''nvim "$@"''; block = true; desc = "Editor"; }
        ];
        system = [
          { run = ''xdg-open "$@"''; desc = "System"; }
        ];
      };

      open = {
        rules = [
          { mime = "{text,application/json}*"; use = "edit"; }

          { name = "*"; use = "system"; }
        ];
      };
    };
  };
}
