qemu-ubuntu:
	sh "$(ROOT_DIR)/tests/qemu/ubuntu/run.sh"

qemu-ubuntu-test:
	sh "$(ROOT_DIR)/tests/qemu/ubuntu/test.sh"

.PHONY: qemu-ubuntu qemu-ubuntu-test
