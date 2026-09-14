function nixpkg_update
  set -l nix_dir "$HOME/.config/home-manager"
  set -l user (whoami)
  set -l last_run_file "$nix_dir/.last_success"

  if test -d $nix_dir
    nix flake update --flake $nix_dir
    # NVIDIA's driver CDN fails with Nix's HTTP/2 client.
    if home-manager switch --flake $nix_dir/#$user --impure --option http2 false
      date +%s > $last_run_file
    end
  end
end
