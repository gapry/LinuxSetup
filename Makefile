fmt:
	find . -path "./.git" -prune -o -name "*.nix" -exec nixpkgs-fmt {} +

test:
	bash ./utils/test.sh

install: ubuntu flatpak download

ubuntu:
	sh ./utils/ubuntu.sh

flatpak:
	sh ./utils/flatpak.sh

snap:
	sh ./utils/snap.sh

download:
	bash ./utils/download.sh

xmonad-test:
	bash ./utils/xmonad-test.sh

nixpkgs-init:
	fish -c 'nixpkg_init'

nixpkgs-update:
	fish -c 'nixpkg_update'

nixpkgs-gc:
	fish -c 'nixpkg_gc'

nixpkgs-channel-version:
	nix eval --inputs-from ~/.config/home-manager nixpkgs#lib.version 

nixpkgs-show-generations:
	home-manager generations

.PHONY: fmt test install ubuntu flatpak snap download xmonad-test nixpkgs-init nixpkgs-update nixpkgs-gc nixpkgs-channel-version nixpkgs-show-generations
