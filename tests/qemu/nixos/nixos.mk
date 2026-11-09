qemu-nixos:
	sh "$(ROOT_DIR)/tests/qemu/nixos/run.sh"

qemu-nixos-test:
	sh "$(ROOT_DIR)/tests/qemu/nixos/test.sh"

.PHONY: qemu-nixos qemu-nixos-test
