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

nixpkg-bytehound:
	mkdir -p "$$HOME/.local/share"
	nix build --out-link "$$HOME/.local/share/bytehound" "$$HOME/.config/home-manager#bytehound"

.PHONY: nixpkgs-init nixpkgs-update nixpkgs-gc nixpkgs-channel-version nixpkgs-show-generations nixpkg-bytehound 
