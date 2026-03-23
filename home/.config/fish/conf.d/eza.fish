if type -q eza
  set -g EZA_IGNORE ".git|node_modules|.cache|build|result"

  alias ezag "eza --icons --group-directories-first"
  alias ezax "eza -lbhHigUmuSa --time-style=long-iso --git --color-scale"
  alias ezat "eza --tree"
  alias ezati "eza -aT -I '$EZA_IGNORE'"
end
