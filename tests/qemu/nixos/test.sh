#!/bin/sh

set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
test_dir="$repo_root/tests/qemu/nixos"
cache_dir="$repo_root/.cache/qemu/nixos"
disk="$cache_dir/test.qcow2"

sh "$repo_root/tests/qemu/sync_shared.sh"
runner=$(sh "$test_dir/build.sh")

rm -f "$disk" "$repo_root/tests/qemu/shared/test.log"

printf 'Fresh VM disk: %s\n' "$disk"
printf 'The test runs in a terminal inside the VM. Log: %s\n' "$repo_root/tests/qemu/shared/test.log"
printf 'Shut down the VM manually when the test ends.\n'

export NIX_DISK_IMAGE="$disk"
export LINUXSETUP_SHARED="$repo_root/tests/qemu/shared"
export QEMU_KERNEL_PARAMS="linuxsetup.test"
exec "$runner"
