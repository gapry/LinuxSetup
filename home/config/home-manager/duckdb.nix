{ pkgs, ... }:

let
  duckdb = pkgs.duckdb.overrideAttrs (oldAttrs: {
    src = pkgs.fetchgit {
      url = "git@github.com:duckdb/duckdb.git";
      rev = "3a3967aa8190d0a2d1931d4ca4f5d920760030b4";
      sha256 = "0bj9akis1yfzz8baqg4k1z25a80c96i5ll90sxavbr0ygjrlnfwx";
    };
  });
in
{
  home.packages = [
    duckdb
  ];
}
