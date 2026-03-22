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

.PHONY: fmt test install ubuntu flatpak snap download xmonad-test
