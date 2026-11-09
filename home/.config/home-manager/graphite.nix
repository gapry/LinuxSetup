{ config, ... }:

{
  imports = [ ./nixgl.nix ];

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/share/graphite-app/bin"
  ];
}

