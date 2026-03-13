function nixpkg_update
  set -l nix_dir "$HOME/.config/home-manager"
  set -l user (whoami)
  set -l last_run_file "$nix_dir/.last_success"

  if test -d $nix_dir
    nix flake update --flake $nix_dir
    if home-manager switch --flake $nix_dir/#$user --impure
      date +%s > $last_run_file
    end
  end
end
