{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    ruby
  ];

  home.sessionVariables = {
    GEM_HOME = "${config.home.homeDirectory}/gems";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/gems/bin"
  ];
}
