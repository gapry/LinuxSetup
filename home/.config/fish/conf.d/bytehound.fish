if test -e ~/.local/share/bytehound/lib/libbytehound.so
  set -gx BYTEHOUND_LIBRARY_PATH (readlink -f ~/.local/share/bytehound/lib/libbytehound.so)
end
