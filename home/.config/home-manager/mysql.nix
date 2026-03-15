{ pkgs, config, ... }:

let
  mysql = pkgs.mysql84;
  dataDir = "${config.home.homeDirectory}/.local/share/mysql";
  runtimeDir = "${config.home.homeDirectory}/.local/run/mysql";
  socketAddr = "${runtimeDir}/mysql.sock";

  mysqlConfig = {
    mysqld = {
      datadir = dataDir;
      socket = socketAddr;
      bind-address = "127.0.0.1";
      port = 3306;
      mysqlx = "OFF";
    };
    client = {
      socket = socketAddr;
    };
  };

  iniFormat = pkgs.formats.ini { };
  myCnf = iniFormat.generate "my.cnf" mysqlConfig;
in
{
  home.packages = [
    mysql
  ];

  systemd.user.services.mysql = {
    Unit = {
      Description = "MySQL 8.4 Server";
      After = [ "network.target" ];
    };

    Service = {
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${dataDir} ${runtimeDir}";
      ExecStart = "${mysql}/bin/mysqld --defaults-file=${myCnf}";

      KillMode = "process";
      Restart = "on-failure";
      TimeoutSec = 300;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  home.activation.setupMysql =
    config.lib.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -d "${dataDir}/mysql" ]; then
        ${mysql}/bin/mysqld \
          --defaults-file=${myCnf} \
          --initialize-insecure \
          --datadir="${dataDir}"
      fi
    '';
}
