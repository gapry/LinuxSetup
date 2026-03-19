{ pkgs, config, ... }:

let
  redis = pkgs.redis;
  dataDir = "${config.home.homeDirectory}/.local/share/redis";
  runtimeDir = "${config.home.homeDirectory}/.local/run/redis";

  redisFormat = pkgs.formats.keyValue {
    listsAsDuplicateKeys = true;
    mkKeyValue = k: v: "${k} ${toString v}";
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

  home.file.".config/redis/redis.conf".source = confFile;
}

