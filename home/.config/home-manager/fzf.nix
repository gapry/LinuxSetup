{ pkgs, ... }:

let
  isCompileFromSourceCode = false;

  fzf-git =
    if isCompileFromSourceCode then
      pkgs.fzf.overrideAttrs
        (oldAttrs: {
          src = pkgs.fetchgit {
            url = "https://github.com/junegunn/fzf.git";
            rev = "eacef5ea6e39c6be3fff4e231fc6d10ba2ff9491";
            sha256 = "0wginamnlp8cs0i54iwhlmwkaswfi8fhkm26bczafzrki31pc6kb";
          };
        })
    else
      pkgs.fzf;
in
{
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    package = fzf-git;
  };
}
