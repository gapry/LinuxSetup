#!/bin/sh

set -u

shared=/mnt/shared/LinuxSetup
export LINUXSETUP_DIR="$shared"
cd "$shared"

fail() {
  printf '[LinuxSetup Test] %s\n' "$1"
  printf 'LINUXSETUP TEST FAILED\n'
  exit 1
}

printf '[LinuxSetup Test] Waiting for cloud-init...\n'
cloud-init status --wait >/dev/null 2>&1 || fail "cloud-init did not finish"

for i in $(seq 1 60); do
  if sudo -n true 2>/dev/null; then
    break
  fi
  sleep 1
done
sudo -n true 2>/dev/null || fail "passwordless sudo is unavailable"

printf '[LinuxSetup Test] Running installer...\n'
sh utils/install.sh || fail "installer exited with status $?"

printf '[LinuxSetup Test] Verifying system...\n'
command -v fish >/dev/null || fail "fish is not installed"
command -v xmonad >/dev/null || fail "xmonad is not installed"
command -v nix >/dev/null || fail "nix is not installed"
command -v snap >/dev/null || fail "snap is not installed"
command -v flatpak >/dev/null || fail "flatpak is not installed"

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
