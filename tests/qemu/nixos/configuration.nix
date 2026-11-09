{ lib, pkgs, ... }:
let
  user = "tester";
  extraPaths = builtins.filter (path: path != "") (lib.splitString ":" (builtins.getEnv "LINUXSETUP_VM_PATHS"));
  shared = "/mnt/shared/LinuxSetup";
  test = pkgs.writeShellScript "linuxsetup-test" ''
    set -u
    export LINUXSETUP_DIR=${shared}
    cd ${shared}

    fail() {
      printf '[LinuxSetup Test] %s\n' "$1"
      printf 'LINUXSETUP TEST FAILED\n'
      exit 1
    }

    printf '[LinuxSetup Test] Running installer...\n'
    sh utils/install.sh || fail "installer exited with status $?"

    printf '[LinuxSetup Test] Verifying system...\n'
    test -f /etc/nixos/flake.nix || fail "/etc/nixos/flake.nix is missing"
    test -f /etc/nixos/flake.lock || fail "/etc/nixos/flake.lock is missing"
    test -f /etc/nixos/wm/xmonad.nix || fail "/etc/nixos/wm/xmonad.nix is missing"
    test -x /run/current-system/sw/bin/fish || fail "fish is not installed"
    test -x /run/current-system/sw/bin/xmonad || fail "xmonad is not installed"
    test -x /run/current-system/sw/bin/ghc || fail "ghc is not installed"

    printf '[LinuxSetup Test] Verifying home...\n'
    test -f "$HOME/.config/home-manager/.last_success" || fail "home-manager did not finish"
    test -f "$HOME/.config/home-manager/flake.lock" || fail "home-manager flake.lock is missing"
    test -f "$HOME/.config/xmonad/xmonad.hs" || fail "xmonad.hs is missing"
    test -f "$HOME/.config/fish/config.fish" || fail "config.fish is missing"
    test -e "$HOME/.nix-profile/bin" || fail "nix profile is missing"
    test -e "$HOME/.local/state/nix/profiles/home-manager" || fail "home-manager profile is missing"
    test -x "$HOME/.local/share/coursier/bin/cs" || fail "coursier is missing"
    test -d "$("$HOME/.local/share/coursier/bin/cs" java-home --jvm temurin:1.25.0.2)/bin" || fail "java is missing"

    printf 'LINUXSETUP TEST PASSED\n'
  '';
  session = pkgs.writeShellScript "linuxsetup-session" ''
    if grep -q -w linuxsetup.test /proc/cmdline; then
      ${test} 2>&1 | tee /mnt/shared/test.log
      printf '\nTest finished. Log saved to /mnt/shared/test.log. Shut down the VM manually.\n'
    fi
    exec "$SHELL" -l
  '';
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "linuxsetup-qemu";

  users.users.${user} = {
    isNormalUser = true;
    initialPassword = user;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };

  security.sudo.wheelNeedsPassword = false;

  services.displayManager.autoLogin = {
    enable = true;
    inherit user;
  };

  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xterm}/bin/xterm -fa Monospace -fs 12 -e ${session} &
  '';

  systemd.tmpfiles.rules = [
    "d /etc/nixos 0755 root root -"
    "C /etc/nixos/configuration.nix 0644 root root - ${./configuration.nix}"
    "C /etc/nixos/hardware-configuration.nix 0644 root root - ${./hardware-configuration.nix}"
  ];

  virtualisation.additionalPaths = map builtins.storePath extraPaths;

  system.stateVersion = "26.05";
}
