function nixpkg_init
  set -l nix_dir "$HOME/.config/home-manager"
  set -l user (whoami)

  if test -d $nix_dir
    # NVIDIA's driver CDN fails with Nix's HTTP/2 client.
    nix run github:nix-community/home-manager/release-26.05 -- switch -b backup --flake $nix_dir/#$user --impure --option http2 false

    if test -d $HOME/.nix-profile/bin
      fish_add_path --move --prepend $HOME/.nix-profile/bin
    end

    date +%s > $nix_dir/.last_success
  else
    echo "Error: Directory $nix_dir not found."
  end
end
