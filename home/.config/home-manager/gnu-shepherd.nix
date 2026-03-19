{ pkgs, ... }:

{
  home.packages = [
    pkgs.gnu-shepherd
  ];

  systemd.user.services.shepherd = {
    Unit = {
      Description = "GNU Shepherd User Daemon";
      After = [ "network.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.gnu-shepherd}/bin/shepherd";
      ExecStop = "${pkgs.gnu-shepherd}/bin/herd stop root";
      Restart = "on-failure";
      RestartSec = "5s";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
