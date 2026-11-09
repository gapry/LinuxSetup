NIXOS_ISO ?= $(ROOT_DIR)/downloads/nixos-minimal-26.05.13627.c56a87d8e41c-x86_64-linux.iso

qemu-nixos:
	NIXOS_ISO="$(abspath $(NIXOS_ISO))" sh "$(ROOT_DIR)/tests/qemu/nixos/run.sh"

.PHONY: qemu-nixos
