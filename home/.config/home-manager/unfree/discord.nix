{ pkgs, ... }:

let
  fcitxGtkCache = pkgs.runCommand "discord-fcitx5-gtk-immodules.cache" { } ''
    ${pkgs.gtk3.dev}/bin/gtk-query-immodules-3.0 \
      ${pkgs.fcitx5-gtk}/lib/gtk-3.0/3.0.0/immodules/im-fcitx5.so > "$out"
  '';
  discord = pkgs.discord.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.asar pkgs.jq ];
    preInstall = (old.preInstall or "") + ''
      gappsWrapperArgs+=(--set GTK_IM_MODULE fcitx --set GTK_IM_MODULE_FILE ${fcitxGtkCache})
    '';
    postFixup = (old.postFixup or "") + ''
      asar extract "$out/opt/Discord/resources/app.asar" discord-app
      cp ${../packages/discord-bootstrap.js} discord-app/discord-bootstrap.js
      jq '.main = "discord-bootstrap.js"' discord-app/package.json > discord-app/package.json.new
      mv discord-app/package.json.new discord-app/package.json
      asar pack discord-app "$out/opt/Discord/resources/app.asar"
    '';
  });
in
{
  home.packages = [ discord ];
}
