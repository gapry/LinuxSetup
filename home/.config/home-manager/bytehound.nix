{ pkgs, lib, ... }:

let
  repoOwner = "koute";
  repoName = "bytehound";
  commitRev = "acce3bce127705ea8c840767ed351229a3c2738c";

  src = pkgs.fetchgit {
    url = "https://github.com/${repoOwner}/${repoName}.git";
    rev = commitRev;
    hash = "sha256-7I2sju0yy2uIn18UV5Rfr7blxh3XGZk32rAJj1oqDdY=";
  };

  webui-deps = pkgs.fetchYarnDeps {
    yarnLock = "${src}/webui/yarn.lock";
    hash = "sha256-cY4VUpskgSUNM2QSnQNdz2prA0b6aK4u9x1cunc5LD8=";
  };

  bytehound = pkgs.stdenv.mkDerivation {
    pname = "bytehound";
    version = "0.11.0";
    inherit src;

    nativeBuildInputs = with pkgs; [
      pkg-config
      cmake
      yarn
      nodejs_24
      rustPlatform.cargoSetupHook
      cargo
      rustc
      python3
      bash
      gnumake
      fixup-yarn-lock
    ];

    buildInputs = with pkgs; [
      openssl
      stdenv.cc.cc.lib
    ];

    cargoDeps = pkgs.rustPlatform.importCargoLock {
      lockFile = "${src}/Cargo.lock";
      outputHashes = {
        "nwind-0.1.0" = "sha256-fhDCxI7DkOATi6DkEX2saJTBPHIXD7bXfOS0w3HtP2I=";
      };
    };

    NODE_OPTIONS = "--openssl-legacy-provider";
    dontUseCmakeConfigure = true;

    buildPhase = ''
      export HOME=$TMPDIR
      
      BASH_EXE=$(type -p bash)
      export SHELL="$BASH_EXE"

      LIBC_DIR=$(dirname $(ldd $(type -p cat) | grep /lib/ | head -n 1 | awk '{print $3}'))
      export NIX_LD="$LIBC_DIR/ld-linux-x86-64.so.2"

      pushd webui
      
      fixup-yarn-lock yarn.lock
      
      export YARN_CACHE_FOLDER=$TMPDIR/yarn-cache
      yarn config --offline set yarn-offline-mirror ${webui-deps}
      yarn install --offline --frozen-lockfile --ignore-scripts --no-progress
      
      patchShebangs node_modules
      popd

      mkdir -p $TMPDIR/bin-override
      ln -s "$BASH_EXE" $TMPDIR/bin-override/sh
      export PATH="$TMPDIR/bin-override:$PATH"

      substituteInPlace server-core/build.rs --replace '"/bin/sh"' '"sh"'
      substituteInPlace server-core/build.rs --replace '"install"' '"install", "--ignore-scripts"'
      
      export RUST_BACKTRACE=full
      cargo build --release -p bytehound-cli
      cargo build --release -p bytehound-preload
    '';

    installPhase = ''
      mkdir -p $out/bin $out/lib
      cp target/release/bytehound $out/bin/bytehound
      cp target/release/libbytehound.so $out/lib/
    '';

    doCheck = false;
  };
in
{
  home.packages = [ bytehound ];
}
