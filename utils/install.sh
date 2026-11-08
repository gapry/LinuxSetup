#!/bin/sh

set -eu

: "${HOME:?HOME must be set}"

for tool in bash curl tar mktemp sudo; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    printf 'Required command not found: %s\n' "$tool" >&2
    exit 1
  fi
done

if [ "$(id -u)" -eq 0 ]; then
  printf 'Run this installer as your regular user, not as root.\n' >&2
  exit 1
fi

. /etc/os-release
if [ "${ID:-}" != ubuntu ] || [ "$(uname -m)" != x86_64 ]; then
  printf 'This installer requires Ubuntu on x86_64.\n' >&2
  exit 1
fi

sudo -v </dev/null

temp_dir=$(mktemp -d)
trap 'rm -rf "$temp_dir"' 0
trap 'exit 1' HUP INT TERM

upstream="https://github.com/gapry/LinuxSetup/archive/refs/heads/main.tar.gz"
printf '[Download] Fetching configurations from %s...\n' "$upstream"
curl -fsSL --output "$temp_dir/archive.tar.gz" "$upstream"

tar -xzf "$temp_dir/archive.tar.gz" -C "$temp_dir" --strip-components=1

bash -e -s -- "$temp_dir" <<'BASH'
repo_root="$1"
cd "$repo_root"

source "$repo_root/utils/color.sh"
source "$repo_root/utils/sync_file.sh"

if [ ! -d "$repo_root/home" ]; then
  printf 'Downloaded archive is missing home/.\n' >&2
  exit 1
fi

timestamp=$(date +%Y%m%d%H%M%S)
mkdir -p "$HOME/backup/LinuxSetup"
backup_root=$(mktemp -d "$HOME/backup/LinuxSetup/install-$timestamp-XXXXXX")

sync_file "$repo_root/home" "$backup_root"

sh "$repo_root/utils/ubuntu.sh" </dev/null
sh "$repo_root/utils/snap.sh" </dev/null
sh "$repo_root/utils/flatpak.sh" </dev/null

user=$(id -un)
# Start with refreshed supplementary groups after ubuntu.sh updates membership.
sudo -u "$user" -- env HOME="$HOME" USER="$user" \
  nix --extra-experimental-features 'nix-command flakes' \
  run github:nix-community/home-manager/release-26.05 -- \
  switch -b "$(basename "$backup_root")" \
  --flake "$HOME/.config/home-manager/#$user" --impure --option http2 false </dev/null

date +%s > "$HOME/.config/home-manager/.last_success"

printf '%s\n' '--------------------------------------------------'
printf 'Installation completed successfully.\n'
printf 'Backup saved at: %s\n' "$backup_root"
printf 'Log out and log back in for group changes to take effect.\n'
printf '%s\n' '--------------------------------------------------'
BASH
