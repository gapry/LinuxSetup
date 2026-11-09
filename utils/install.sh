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
os_id="${ID:-}"

case "$os_id" in
  ubuntu|nixos) ;;
  *)
    printf 'This installer requires Ubuntu or NixOS.\n' >&2
    exit 1
    ;;
esac

if [ "$(uname -m)" != x86_64 ]; then
  printf 'This installer requires x86_64.\n' >&2
  exit 1
fi

if [ -n "${LINUXSETUP_DIR:-}" ] && [ -n "${LINUXSETUP_REF:-}" ]; then
  printf 'Set only one of LINUXSETUP_DIR or LINUXSETUP_REF.\n' >&2
  exit 1
fi

sudo -v </dev/null

if [ -n "${LINUXSETUP_DIR:-}" ]; then
  if [ ! -d "$LINUXSETUP_DIR" ]; then
    printf 'LINUXSETUP_DIR is not a directory: %s\n' "$LINUXSETUP_DIR" >&2
    exit 1
  fi
  repo_root=$(CDPATH= cd -- "$LINUXSETUP_DIR" && pwd)
  printf '[Source] Using local configurations from %s\n' "$repo_root"
else
  temp_dir=$(mktemp -d)
  trap 'rm -rf "$temp_dir"' 0
  trap 'exit 1' HUP INT TERM

  ref="${LINUXSETUP_REF:-main}"
  upstream="https://github.com/gapry/LinuxSetup/archive/${ref}.tar.gz"
  printf '[Download] Fetching configurations from %s...\n' "$upstream"
  curl -fsSL --output "$temp_dir/archive.tar.gz" "$upstream"
  tar -xzf "$temp_dir/archive.tar.gz" -C "$temp_dir" --strip-components=1
  repo_root="$temp_dir"
fi

if [ ! -d "$repo_root/home" ] || [ ! -d "$repo_root/utils/os" ]; then
  printf 'Configuration source is missing home/ or utils/os/.\n' >&2
  exit 1
fi

bash -e -s -- "$repo_root" "$os_id" <<'BASH'
repo_root="$1"
os_id="$2"
cd "$repo_root"

source "$repo_root/utils/color.sh"
source "$repo_root/utils/sync_file.sh"

timestamp=$(date +%Y%m%d%H%M%S)
mkdir -p "$HOME/backup/LinuxSetup"
backup_root=$(mktemp -d "$HOME/backup/LinuxSetup/install-$timestamp-XXXXXX")

sync_file "$repo_root/home" "$backup_root"

sh "$repo_root/utils/os/$os_id.sh" </dev/null

user=$(id -un)
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
