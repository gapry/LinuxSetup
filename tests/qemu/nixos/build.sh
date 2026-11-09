#!/bin/sh

set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
test_dir="$repo_root/tests/qemu/nixos"
cache_dir="$repo_root/.cache/qemu/nixos"
vm_link="$cache_dir/vm"

for tool in nix python3 qemu-system-x86_64; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    printf 'Required command not found: %s\n' "$tool" >&2
    exit 1
  fi
done

if [ ! -r /dev/kvm ] || [ ! -w /dev/kvm ]; then
  printf 'KVM is unavailable. Enable hardware virtualization and access to /dev/kvm.\n' >&2
  exit 1
fi

if [ -z "${DISPLAY:-}" ] && [ -z "${WAYLAND_DISPLAY:-}" ]; then
  printf 'A graphical session is required to display the NixOS VM.\n' >&2
  exit 1
fi

mkdir -p "$cache_dir"

flake_dir=$(mktemp -d)
trap 'rm -rf "$flake_dir"' 0
trap 'exit 1' HUP INT TERM

cp -R "$repo_root/etc/nixos/." "$flake_dir/"
cp "$test_dir/configuration.nix" "$test_dir/hardware-configuration.nix" "$flake_dir/"

hm_dir="$repo_root/home/.config/home-manager"
hm_user=tester
hm_home="/home/$hm_user"

printf 'Building Home Manager for %s...\n' "$hm_user" >&2
hm_package=$(env USER="$hm_user" HOME="$hm_home" \
  XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}" \
  XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}" \
  XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}" \
  nix --extra-experimental-features 'nix-command flakes' build \
  --impure --no-link --print-out-paths \
  "path:$hm_dir#homeConfigurations.$hm_user.activationPackage")

hm_inputs=$(nix --extra-experimental-features 'nix-command flakes' flake archive \
  --json "path:$hm_dir" | python3 -c '
import json, sys

def walk(node):
  yield node["path"]
  for child in node.get("inputs", {}).values():
    yield from walk(child)

print(":".join(walk(json.load(sys.stdin))))
')

export LINUXSETUP_VM_PATHS="$hm_package:$hm_inputs"

printf 'Building NixOS VM...\n' >&2
nix --extra-experimental-features 'nix-command flakes' build \
  --impure --out-link "$vm_link" \
  "path:$flake_dir#nixosConfigurations.linuxsetup.config.system.build.vm"

runner="$vm_link/bin/run-linuxsetup-qemu-vm"
if [ ! -x "$runner" ]; then
  printf 'VM runner not found: %s\n' "$runner" >&2
  exit 1
fi

printf '%s\n' "$runner"
