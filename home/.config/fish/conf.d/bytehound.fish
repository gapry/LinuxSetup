if test -e ~/.nix-profile/lib/libbytehound.so
  set -gx BYTEHOUND_LIBRARY_PATH (readlink -f ~/.nix-profile/lib/libbytehound.so)
end
