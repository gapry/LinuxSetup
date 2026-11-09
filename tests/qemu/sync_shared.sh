#!/bin/sh

set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
shared_dir="$repo_root/tests/qemu/shared"
target_dir="$shared_dir/LinuxSetup"

mkdir -p "$shared_dir"
rm -rf "$target_dir"
mkdir -p "$target_dir"

tar -C "$repo_root" \
  --exclude=./.git \
  --exclude=./.cache \
  --exclude=./downloads \
  --exclude=./result \
  --exclude='./result-*' \
  --exclude=./tests/qemu/shared \
  -cf - . | tar -C "$target_dir" -xf -

printf 'Shared directory: %s\n' "$shared_dir"
printf 'Mount in guest: sudo mkdir -p /mnt/shared && sudo mount -t 9p -o trans=virtio,version=9p2000.L,ro shared /mnt/shared\n'
printf 'Install in guest: env LINUXSETUP_DIR=/mnt/shared/LinuxSetup sh /mnt/shared/LinuxSetup/utils/install.sh\n'
