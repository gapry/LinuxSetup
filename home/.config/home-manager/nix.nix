{ pkgs, ... }:

{
  nix = {
    package = pkgs.nix;

    enable = true;

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
  };
}
