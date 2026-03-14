{ pkgs, config, ... }:

let
  postgre = pkgs.postgresql_18;
  dataDir = "${config.home.homeDirectory}/.local/share/postgresql";
  socketDir = "${config.home.homeDirectory}/.local/run/postgres";
in
{
  home.packages = [
    postgre
  ];

  systemd.user.services.postgresql = {
    Unit = {
      Description = "PostgreSQL database server";
      After = [ "network.target" ];
    };

    Service = {
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${socketDir}";
      ExecStart = "${postgre}/bin/postgres -D ${dataDir} -k ${socketDir}";
      ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";

      KillMode = "mixed";
      KillSignal = "SIGINT";

      TimeoutStopSec = "infinity";

      Environment = "LC_ALL=C";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  home.activation.setupPostgres =
    config.lib.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -d "${dataDir}" ]; then
        ${postgre}/bin/initdb -D "${dataDir}"
      fi
    '';
}
