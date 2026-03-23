if type -q eza
  set -g EZA_IGNORE ".git|node_modules|.cache|build|result"

  alias ezag "eza --icons --group-directories-first"

  alias ezat "eza -aT -I '$EZA_IGNORE'"
end
