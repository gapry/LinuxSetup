{ pkgs, ... }:

let
  discord = pkgs.discord.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.asar pkgs.jq ];
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
