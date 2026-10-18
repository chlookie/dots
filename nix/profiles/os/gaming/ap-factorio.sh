self=$(readlink -f "$0")

if [[ -n "${AP_FACTORIO_SHIM:-}" ]]; then
  # ---- shim mode: the client thinks we are the factorio binary ----
  args=()
  cfg=""
  mode=""
  while (($#)); do
    case "$1" in
      --config) cfg="$2"; shift 2 ;;
      --mod-directory) shift 2 ;;
      --create) mode=create; shift 2 ;;
      --start-server) mode=start; shift 2 ;;
      *) args+=("$1"); shift ;;
    esac
  done

  case "$mode" in
    create)
      [[ -f "$AP_RUN/save.zip" ]] && exit 0
      args+=(--create "$AP_RUN/save.zip")
      [[ -n "${SEED:-}" ]] && args+=(--map-gen-seed "$SEED")
      ;;
    start) args+=(--start-server "$AP_RUN/save.zip") ;;
  esac

  wd=""
  [[ -f "$cfg" ]] && wd=$(sed -n 's/^write-data=//p' "$cfg")
  cat > "$AP_TMP/factorio.ini" <<EOF
[path]
read-data=$FDATA
write-data=${wd:-$AP_TMP/factorio}

[other]
use-system-read-write-data-directories=false
EOF

  exec factorio --config "$AP_TMP/factorio.ini" --mod-directory "$AP_RUN/mods" "${args[@]}"
fi

# ---- launcher mode ----
AP_RUN=$PWD
if [[ -f .env ]]; then
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
fi

if ! compgen -G "$AP_RUN/mods/AP_*.zip" > /dev/null; then
  echo "No ./mods/AP_*.zip found in $AP_RUN" >&2
  exit 1
fi

AP_TMP=$(mktemp -d)
trap 'rm -rf "$AP_TMP"' EXIT
export AP_RUN AP_TMP AP_FACTORIO_SHIM=1 XDG_DATA_HOME="$AP_TMP/data"

mkdir -p "$XDG_DATA_HOME/Archipelago"
cat > "$XDG_DATA_HOME/Archipelago/host.yaml" <<EOF
factorio_options:
  executable: $self
EOF

archipelago "Factorio Client" -- --nogui "$@"