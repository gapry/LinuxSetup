#!/bin/sh

set -eu

test_os_url=https://cloud-images.ubuntu.com/releases/resolute/release/ubuntu-26.04-server-cloudimg-amd64.img

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
cd "$repo_root"

for tool in qemu-system-x86_64 qemu-img xorriso; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    printf 'Required command not found: %s\n' "$tool" >&2
    exit 1
  fi
done

if [ ! -r /dev/kvm ] || [ ! -w /dev/kvm ]; then
  printf 'KVM is unavailable. Enable hardware virtualization and access to /dev/kvm.\n' >&2
  exit 1
fi

if [ ! -t 0 ] || [ ! -t 1 ]; then
  printf 'Run make %s in an interactive terminal.\n' "$make_target" >&2
  exit 1
fi

image=
for candidate in downloads/*.img; do
  if [ -f "$candidate" ] && [ -r "$candidate" ] && [ -s "$candidate" ] &&
    qemu-img info -f qcow2 "$candidate" >/dev/null 2>&1; then
    image=$candidate
    break
  fi
done

if [ -z "$image" ]; then
  mkdir -p downloads
  image="downloads/${test_os_url##*/}"
  if [ -e "$image" ]; then
    printf 'Invalid cloud image: %s. Move it aside before retrying.\n' "$image" >&2
    exit 1
  fi
  download="$image.part"
  trap 'rm -f "$download"' 0
  trap 'exit 1' HUP INT TERM
  curl -fL --output "$download" "$test_os_url"
  qemu-img info -f qcow2 "$download" >/dev/null
  mv "$download" "$image"
  trap - 0 HUP INT TERM
fi

mkdir -p .cache/qemu
if [ ! -e "$disk" ]; then
  qemu-img create -f qcow2 -F qcow2 -b "$repo_root/$image" "$disk" 100G
fi

xorriso -as mkisofs -quiet -volid cidata -joliet -rock \
  -output "$seed.tmp" -graft-points \
  "user-data=$user_data" meta-data=tests/qemu/ubuntu/instance.yaml
mv "$seed.tmp" "$seed"

sh "$repo_root/tests/qemu/sync_shared.sh"

run_qemu() {
  exec qemu-system-x86_64 \
    -enable-kvm \
    -cpu host \
    -smp 4 \
    -m 8G \
    -drive "file=$disk,format=qcow2,if=virtio" \
    -drive "file=$seed,format=raw,media=cdrom,readonly=on" \
    -nic user,model=virtio-net-pci \
    -virtfs "local,path=$repo_root/tests/qemu/shared,mount_tag=shared,security_model=mapped-xattr" \
    -nographic
}
