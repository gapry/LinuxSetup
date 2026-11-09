#!/bin/sh

set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

if ! command -v nix >/dev/null 2>&1; then
  printf 'Required command not found: nix\n' >&2
  exit 1
fi

sync_lock() {
  flake_dir="$1"
  deployed_lock="$2"

  if [ -n "$deployed_lock" ] && [ -f "$deployed_lock" ]; then
    cp "$deployed_lock" "$flake_dir/flake.lock"
    printf '[Copy] %s -> %s/flake.lock\n' "$deployed_lock" "$flake_dir"
  else
    nix --extra-experimental-features 'nix-command flakes' flake lock "path:$flake_dir"
    printf '[Lock] %s/flake.lock\n' "$flake_dir"
  fi
}

sync_lock "$repo_root/home/.config/home-manager" "$HOME/.config/home-manager/flake.lock"

if [ -e /etc/NIXOS ]; then
  sync_lock "$repo_root/etc/nixos" /etc/nixos/flake.lock
else
  sync_lock "$repo_root/etc/nixos" ""
fi
