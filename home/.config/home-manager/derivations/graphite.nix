{ pkgs }:

let
  graphitePkgs = import pkgs.path {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfreePredicate =
      pkg: pkgs.lib.getName pkg == "graphite";
  };
in
graphitePkgs.graphite
