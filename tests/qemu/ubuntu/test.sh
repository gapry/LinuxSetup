#!/bin/sh

set -eu

make_target=qemu-ubuntu-test
disk=.cache/qemu/ubuntu-test.qcow2
seed=.cache/qemu/ubuntu-test-seed.iso
user_data=tests/qemu/ubuntu/cloud-init-test.yaml

. "$(dirname -- "$0")/common.sh"


printf 'Using cloud image: %s\n' "$image"
printf 'VM disk: %s\n' "$disk"
printf 'The test runs after login. Log: %s\n' "$repo_root/tests/qemu/shared/test.log"
printf 'To shut down: sudo poweroff. To exit immediately: Ctrl+a, then x.\n'

run_qemu
