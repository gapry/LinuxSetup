{ config, ... }:

{
  home.sessionPath = [
    "${config.home.homeDirectory}/.local/share/bytehound/bin"
  ];
}
