#!/bin/sh

set -eu

make_target=qemu-ubuntu
disk=.cache/qemu/ubuntu.qcow2
seed=.cache/qemu/ubuntu-seed.iso
user_data=tests/qemu/ubuntu/cloud-init.yaml

. "$(dirname -- "$0")/common.sh"

printf 'Using cloud image: %s\n' "$image"
printf 'Waiting for Ubuntu to initialize and log in as ubuntu.\n'
printf 'Changes are saved in: %s\n' "$disk"
printf 'Shared directory in guest: /mnt/shared/LinuxSetup\n'
printf 'To shut down: sudo poweroff. To exit immediately: Ctrl+a, then x.\n'

run_qemu
