test:
	sh ./utils/test.sh

install:
	sh ./utils/install.sh

fmt:
	find . -name "*.nix" -exec nixpkgs-fmt {} +

.PHONY: test install fmt
