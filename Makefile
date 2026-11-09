ROOT_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

include $(ROOT_DIR)/pkgs/ubuntu/ubuntu.mk
include $(ROOT_DIR)/pkgs/snap/snap.mk
include $(ROOT_DIR)/pkgs/flatpak/flatpak.mk
include $(ROOT_DIR)/pkgs/nix/nixpkgs.mk
include $(ROOT_DIR)/tests/qemu/qemu.mk
include $(ROOT_DIR)/tests/xmonad/xmonad.mk

local:
	bash "$(ROOT_DIR)/utils/local.sh"

format:
	cd "$(ROOT_DIR)" && find . -path "./.git" -prune -o -name "*.nix" -exec nixpkgs-fmt {} +

.PHONY: local format
