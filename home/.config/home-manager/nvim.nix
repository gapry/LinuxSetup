{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    sideloadInitLua = true;
    withRuby = true;
    withPython3 = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs; [
      gcc
      gnumake
      unzip
      tree-sitter
    ];
  };
}
