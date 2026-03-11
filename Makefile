test:
	sh ./utils/test.sh

install:
	sh ./utils/install.sh

ubuntu:
	sh ./utils/ubuntu.sh

fmt:
	find . -name "*.nix" -exec nixpkgs-fmt {} +

.PHONY: test install fmt ubuntu
