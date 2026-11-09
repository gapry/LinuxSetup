#!/bin/sh

set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
test_dir="$repo_root/tests/qemu/nixos"
cache_dir="$repo_root/.cache/qemu/nixos"
disk="$cache_dir/vm.qcow2"

sh "$repo_root/tests/qemu/sync_shared.sh"
runner=$(sh "$test_dir/build.sh")

printf 'Persistent VM disk: %s\n' "$disk"
printf 'Shared directory in guest: /mnt/shared/LinuxSetup\n'
printf 'Login: tester / tester\n'
printf 'Close the QEMU window to exit.\n'

export NIX_DISK_IMAGE="$disk"
export LINUXSETUP_SHARED="$repo_root/tests/qemu/shared"
exec "$runner"
