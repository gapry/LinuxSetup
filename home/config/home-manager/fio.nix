{ pkgs, ... }:

let
  fio = pkgs.fio.overrideAttrs (oldAttrs: {
    src = pkgs.fetchgit {
      url = "https://github.com/axboe/fio.git";
      rev = "3a0e8ddf28ad32785ea3130ce0ee42524d835d60";
      sha256 = "05shfw2s9zjj89p5sxzdld70k2rayy2hx5aglmgrc2wi7adqz1qv";
    };
  });
in
{
  home.packages = [
    fio
  ];
}
