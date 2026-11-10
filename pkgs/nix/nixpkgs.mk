nixpkgs-init:
	fish -c 'nixpkg_init'

nixpkgs-update:
	fish -c 'nixpkg_update'

nixpkgs-gc:
	fish -c 'nixpkg_gc'

nixpkgs-remove-all-generations:
	nix-collect-garbage -d

nixpkgs-channel-version:
	nix eval --inputs-from ~/.config/home-manager nixpkgs#lib.version

nixpkgs-show-generations:
	home-manager generations

nixpkg-bytehound:
	mkdir -p "$$HOME/.local/share"
	nix build --out-link "$$HOME/.local/share/bytehound" "$$HOME/.config/home-manager#bytehound"

nixpkg-graphite:
	mkdir -p "$$HOME/.local/share"
	nix build --impure --out-link "$$HOME/.local/share/graphite-app" "$$HOME/.config/home-manager#graphite"

.PHONY: nixpkgs-init nixpkgs-update nixpkgs-gc nixpkgs-channel-version nixpkgs-show-generations nixpkg-bytehound nixpkg-graphite nixpkgs-remove-all-generations
