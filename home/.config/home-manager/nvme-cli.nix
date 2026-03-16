{ pkgs, ... }:

{
  # usage
  #
  # sudo $(which nvme) list
  # sudo $(which nvme) smart-log /dev/<nvme>
  #
  home.packages = [
    pkgs.nvme-cli 
  ];
}
