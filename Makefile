fmt:
	find . -name "*.nix" -exec nixpkgs-fmt {} +

test:
	sh ./utils/test.sh

install: ubuntu flatpak download

ubuntu:
	sh ./utils/ubuntu.sh

flatpak:
	sh ./utils/flatpak.sh

download:
	sh ./utils/download.sh

.PHONY: fmt test install ubuntu flatpak download
