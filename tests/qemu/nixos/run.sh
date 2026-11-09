#!/bin/sh

set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
nixos_iso_url=https://releases.nixos.org/nixos/26.05/nixos-26.05.13627.c56a87d8e41c/nixos-minimal-26.05.13627.c56a87d8e41c-x86_64-linux.iso
nixos_iso=${NIXOS_ISO:-"$repo_root/downloads/${nixos_iso_url##*/}"}

for tool in qemu-system-x86_64 qemu-img; do
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
  printf 'A graphical session is required to display the NixOS installer.\n' >&2
  exit 1
fi

if [ -e "$nixos_iso" ] &&
  { [ ! -f "$nixos_iso" ] || [ ! -r "$nixos_iso" ] || [ ! -s "$nixos_iso" ]; }; then
  printf 'NixOS ISO is not a readable, non-empty file: %s. Move it aside before retrying.\n' "$nixos_iso" >&2
  exit 1
fi

if [ ! -e "$nixos_iso" ]; then
  if ! command -v curl >/dev/null 2>&1; then
    printf 'Required command not found: curl\n' >&2
    exit 1
  fi

  mkdir -p "$(dirname "$nixos_iso")"
  download="$nixos_iso.part"
  trap 'rm -f "$download"' 0
  trap 'exit 1' HUP INT TERM
  printf 'Downloading NixOS ISO from %s...\n' "$nixos_iso_url"
  curl -fL --output "$download" "$nixos_iso_url"
  if [ ! -s "$download" ]; then
    printf 'Downloaded NixOS ISO is empty.\n' >&2
    exit 1
  fi
  mv "$download" "$nixos_iso"
  trap - 0 HUP INT TERM
fi

nixos_disk_dir="$repo_root/.cache/qemu/nixos"
nixos_disk="$nixos_disk_dir/nixos.qcow2"
mkdir -p "$nixos_disk_dir"

if [ -e "$nixos_disk" ]; then
  if ! qemu-img info -f qcow2 "$nixos_disk" >/dev/null 2>&1; then
    printf 'Invalid NixOS VM disk: %s. Move it aside before retrying.\n' "$nixos_disk" >&2
    exit 1
  fi
else
  qemu-img create -f qcow2 "$nixos_disk" 100G
fi

printf 'Using NixOS ISO: %s\n' "$nixos_iso"
printf 'Persistent VM disk: %s\n' "$nixos_disk"
printf 'Install NixOS to /dev/vda on the first boot; later boots prefer the installed system.\n'
printf 'Close the QEMU window to exit.\n'

exec qemu-system-x86_64 \
  -enable-kvm \
  -cpu host \
  -smp 4 \
  -m 8G \
  -drive "file=$nixos_disk,format=qcow2,if=virtio" \
  -cdrom "$nixos_iso" \
  -boot order=cd \
  -nic user,model=virtio-net-pci \
  -display gtk
