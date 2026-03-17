function reset_fcitx5 --description 'Reset Fcitx5'
  if type -q fcitx5
    killall fcitx5
    rm -rf ~/.local/share/fcitx5/rime/build
    fcitx5 -rd
  end
end
