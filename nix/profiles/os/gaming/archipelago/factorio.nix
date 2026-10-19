{ pkgs, user, ... }:

let
  factorio = pkgs.unstable.factorio-headless;
  factorioData = "${factorio}/share/factorio/data";

  factorioWrapped = pkgs.writeShellApplication {
    name = "archipelago-factorio-server-wrapped";
    runtimeInputs = [
      factorio
    ];

    text = ''
      RUN_DIR=$PWD

      set -- "$RUN_DIR"/mods/AP*.zip
      if [ ! -e "$1" ]; then
        echo "No AP mod found in mods/"
        exit 1
      fi

      if [ ! -f mods/mod-list.json ]; then
          cat > mods/mod-list.json <<'EOF'
      {
        "mods":
        [

          {
            "name": "base",
            "enabled": true
          },

          {
            "name": "elevated-rails",
            "enabled": false
          },

          {
            "name": "quality",
            "enabled": false
          },

          {
            "name": "space-age",
            "enabled": false
          }
        ]
      }
      EOF
      fi

      # The archipelago factorio client runs this script and passes arguments we need to replace
      args=()
      while (($#)); do
        case "$1" in
          --config) shift 2 ;;
          --mod-directory) shift 2 ;;
          --create) args+=(--create "$RUN_DIR/save.zip"); shift 2 ;;
          --start-server) args+=(--start-server "$RUN_DIR/save.zip"); shift 2 ;;
          *) args+=("$1"); shift ;;
        esac
      done

      DATA_DIR=$RUN_DIR/data
      CFG_FILE=$DATA_DIR/factorio.ini

      mkdir --parents "$DATA_DIR"
      mkdir --parents "$(dirname "$CFG_FILE")"

      cat > "$CFG_FILE" <<EOF
      [path]
      read-data=${factorioData}
      write-data=$DATA_DIR

      [other]
      use-system-read-write-data-directories=false
      EOF

      exec factorio --config "$CFG_FILE" --mod-directory "$RUN_DIR/mods" "''${args[@]}"
    '';
  };
in
{
  environment.systemPackages = [
    factorio
    factorioWrapped
  ];

  home-manager.users.${user}.home.shellAliases = {
    ap-factorio = ''archipelago "Factorio Client" -- --nogui'';
  };
}
