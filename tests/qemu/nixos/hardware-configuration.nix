{ modulesPath, ... }:
{
  imports = [
    "${modulesPath}/virtualisation/qemu-vm.nix"
  ];

  boot.loader.grub.enable = false;

  boot.initrd.availableKernelModules = [
    "virtio_pci"
    "virtio_blk"
    "virtio_net"
    "9p"
    "9pnet_virtio"
  ];

  virtualisation = {
    cores = 4;
    memorySize = 8192;
    diskSize = 102400;
    graphics = true;
    qemu.options = [
      "-vga virtio"
    ];
    sharedDirectories.linuxsetup = {
      source = "\"$LINUXSETUP_SHARED\"";
      target = "/mnt/shared";
      securityModel = "mapped-xattr";
    };
  };
}
