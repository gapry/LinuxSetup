{ pkgs, ... }:

let
  fzf-git = pkgs.fzf.overrideAttrs (oldAttrs: {
    src = pkgs.fetchgit {
      url = "git@github.com:junegunn/fzf.git";
      rev = "eacef5ea6e39c6be3fff4e231fc6d10ba2ff9491";
      sha256 = "0wginamnlp8cs0i54iwhlmwkaswfi8fhkm26bczafzrki31pc6kb";
    };
  });
in
{
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    package = fzf-git;
  };
}
