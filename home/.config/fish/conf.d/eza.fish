if type -q eza
  set -g EZA_IGNORE ".git|node_modules|.cache|build|result"

  alias ls "eza --icons --group-directories-first"
  
  alias l "ls -l"
  alias la "ls -a"
  alias ll "ls -al"
  
  alias lt "ls --tree"
  alias lx "ls -lbhHigUmuSa --time-style=long-iso --git --color-scale"

  alias tree "eza -aT -I '$EZA_IGNORE'"
end
