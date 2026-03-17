function init_fcitx5 --description 'Init Fcitx5'
  if type -q im-config
    im-config -n fcitx5
  end
end
