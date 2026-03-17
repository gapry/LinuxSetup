function init_fcitx5 --description 'Init Fcitx5 and Rime Cangjie'
  if type -q im-config
    im-config -n fcitx5
  end
end
