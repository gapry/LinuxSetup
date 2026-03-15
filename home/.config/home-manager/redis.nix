{ pkgs, config, ... }:

let
  redis = pkgs.redis;
  dataDir = "${config.home.homeDirectory}/.local/share/redis";
  runtimeDir = "${config.home.homeDirectory}/.local/run/redis";

  redisFormat = pkgs.formats.keyValue {
    listsAsDuplicateKeys = true;
  };

  redisConfig = {
    port = 6379;
    bind = "127.0.0.1";
    dir = dataDir;
    pidfile = "${runtimeDir}/redis.pid";
    unixsocket = "${runtimeDir}/redis.sock";
    unixsocketperm = 700;
    daemonize = "no";
    "protected-mode" = "yes";
    save = "60 1"; # https://redis.io/docs/latest/operate/oss_and_stack/management/persistence/
  };

  confFile = redisFormat.generate "redis.conf" redisConfig;
in
{
  home.packages = [
    redis
  ];

  systemd.user.services.redis = {
    Unit = {
      Description = "Redis Key-Value Store";
      After = [ "network.target" ];
    };

    Service = {
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${dataDir} ${runtimeDir}";
      ExecStart = "${redis}/bin/redis-server ${confFile}";

      ExecStop = "${redis}/bin/redis-cli -s ${runtimeDir}/redis.sock shutdown";
      Restart = "on-failure";
      Type = "simple";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
