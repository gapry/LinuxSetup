{ pkgs, config, lib, ... }:

let
  postgresql = pkgs.postgresql_18;
  dataDir = "${config.home.homeDirectory}/.local/share/postgresql";
  socketDir = "${config.home.homeDirectory}/.local/run/postgres";
  settings = ../../settings/postgresql;
  postgresqlConfig = pkgs.replaceVars (settings + "/postgresql.conf") {
    socketDir = lib.replaceStrings [ "\\" "'" ] [ "\\\\" "\\'" ] socketDir;
    hbaFile = "${settings}/pg_hba.conf";
  };
  setupArgs = lib.escapeShellArgs [
    "${postgresql}/bin"
    dataDir
    socketDir
  ];
in
{
  home.packages = [
    postgresql
  ];

  xdg.configFile."postgresql/postgresql.conf".source = postgresqlConfig;

  home.activation.setupPostgres =
    config.lib.dag.entryBetween [ "reloadSystemd" ] [ "writeBoundary" ] ''
      PATH=${lib.escapeShellArg (lib.makeBinPath [ pkgs.coreutils ])} \
        ${pkgs.bash}/bin/bash ${settings + "/setup.sh"} ${setupArgs}
    '';
}
