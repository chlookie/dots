{ pkgs, ... }:

let
  factorio = pkgs.unstable.factorio-headless;
  factorioData = "${factorio}/share/factorio/data";

  factorioWrapped = pkgs.writeShellApplication {
    name = "archipelago-factorio";
    runtimeInputs = [
      factorio
    ];

    text = ''
      #bash

      RUN_DIR=$PWD

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

      TMP=$(mktemp -d)
      trap 'rm -rf "$TMP"' EXIT

      cat > "$TMP/factorio.ini" <<EOF
      [path]
      read-data=${factorioData}
      write-data=$RUN_DIR/factorio-write-data

      [other]
      use-system-read-write-data-directories=false
      EOF

      factorio --config "$TMP/factorio.ini" --mod-directory "$RUN_DIR/mods" "''${args[@]}"
    '';
  };
in
{

  environment.systemPackages = [
    factorio
    factorioWrapped
  ];
}
