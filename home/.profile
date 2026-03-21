if [ -n "$BASH_VERSION" ]; then
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
  PATH="$HOME/.local/bin:$PATH"
fi

if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then 
  . $HOME/.nix-profile/etc/profile.d/nix.sh; 
fi 
