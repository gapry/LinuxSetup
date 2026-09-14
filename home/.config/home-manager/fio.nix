{ pkgs, ... }:

let
  fio = pkgs.fio.overrideAttrs (oldAttrs: {
    src = pkgs.fetchgit {
      url = "https://github.com/axboe/fio.git";
      rev = "3a0e8ddf28ad32785ea3130ce0ee42524d835d60";
      sha256 = "05shfw2s9zjj89p5sxzdld70k2rayy2hx5aglmgrc2wi7adqz1qv";
    };
    # Overriding src still inherits patches from pkgs.fio. The pinned revision
    # already includes this linux/falloc.h fix, so applying it again fails with
    # "Reversed (or previously applied) patch detected". Remove only that patch
    # rather than clearing the list, preserving any other nixpkgs fixes.
    # Fall back to an empty list if pkgs.fio no longer defines patches.
    patches = builtins.filter
      (patch: !(pkgs.lib.hasSuffix "ccce76d2850d6e52da3d7986c950af068fbfe0fd.patch" (toString patch)))
      (oldAttrs.patches or [ ]);
  });
in
{
  home.packages = [
    fio
  ];
}
