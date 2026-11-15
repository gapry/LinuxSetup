{ pkgs, config, lib, ... }:

let
  mysql = pkgs.mysql84;
  dataDir = "${config.home.homeDirectory}/.local/share/mysql";
  runtimeDir = "${config.home.homeDirectory}/.local/run/mysql";
  socketAddr = "${runtimeDir}/mysql.sock";
  settings = ../../settings/mysql;
  myCnf = pkgs.replaceVars (settings + "/my.cnf") {
    inherit dataDir socketAddr;
  };
  setupArgs = lib.escapeShellArgs [
    "${mysql}/bin"
    myCnf
    dataDir
    runtimeDir
    socketAddr
    (settings + "/setup.sql")
  ];
in
{
  home.packages = [
    mysql
  ];

  home.file.".my.cnf".source = myCnf;

  home.activation.setupMysql =
    config.lib.dag.entryBetween [ "reloadSystemd" ] [ "writeBoundary" ] ''
      PATH=${lib.escapeShellArg (lib.makeBinPath [ pkgs.coreutils ])} \
        ${pkgs.bash}/bin/bash ${settings + "/setup.sh"} ${setupArgs}
    '';
}
