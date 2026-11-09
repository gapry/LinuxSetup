#!/bin/sh

set -e

for tool in nixos-rebuild sudo; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    printf 'Required command not found: %s\n' "$tool" >&2
    exit 1
  fi
done

source_dir="etc/nixos"
target_dir="/etc/nixos"

for file in configuration.nix hardware-configuration.nix; do
  if [ ! -f "$target_dir/$file" ]; then
    printf 'Missing %s. Install NixOS first.\n' "$target_dir/$file" >&2
    exit 1
  fi
done

if [ ! -f "$source_dir/flake.nix" ] || [ ! -f "$source_dir/flake.lock" ]; then
  printf 'Repository is missing %s/flake.nix or flake.lock.\n' "$source_dir" >&2
  exit 1
fi

timestamp=$(date +%Y%m%d%H%M%S)
backup_dir="/var/backup/linuxsetup/nixos-$timestamp"

echo "Backing up existing NixOS configuration..."
sudo mkdir -p "$backup_dir"
sudo cp -a "$target_dir/." "$backup_dir/"

echo "Deploying NixOS flake..."
for entry in "$source_dir"/*; do
  name=$(basename "$entry")
  case "$name" in
    configuration.nix|hardware-configuration.nix) continue ;;
  esac
  sudo rm -rf "$target_dir/$name"
  sudo cp -R "$entry" "$target_dir/$name"
  sudo chown -R root:root "$target_dir/$name"
  sudo chmod -R u=rwX,go=rX "$target_dir/$name"
done

echo "Rebuilding NixOS..."
sudo nixos-rebuild switch --flake "$target_dir#linuxsetup"

user=$(whoami)

for group in docker networkmanager; do
  if getent group "$group" >/dev/null 2>&1 && ! id -nG "$user" | grep -q -w "$group"; then
    sudo usermod -aG "$group" "$user"
    echo "Added $user to $group group. Log out and log back in for group changes to apply."
  fi
done

sh pkgs/curl/curl.sh

echo "NixOS setup completed."
