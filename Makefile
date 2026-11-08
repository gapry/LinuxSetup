ROOT_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

include $(ROOT_DIR)/pkgs/ubuntu/ubuntu.mk
include $(ROOT_DIR)/pkgs/snap/snap.mk
include $(ROOT_DIR)/pkgs/flatpak/flatpak.mk
include $(ROOT_DIR)/pkgs/nix/nixpkgs.mk

local:
	bash "$(ROOT_DIR)/utils/local.sh"

install:
	sh "$(ROOT_DIR)/utils/install.sh"

xmonad-test:
	bash "$(ROOT_DIR)/utils/xmonad-test.sh"

format:
	cd "$(ROOT_DIR)" && find . -path "./.git" -prune -o -name "*.nix" -exec nixpkgs-fmt {} +

.PHONY: local install xmonad-test format
