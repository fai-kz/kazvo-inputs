#!/bin/bash
set -Eeuo pipefail

cd /var/gavo/inputs/rr

lock_dir=/var/tmp/dachs-rr-harvest
mkdir -p "$lock_dir"
chmod 0700 "$lock_dir"
exec 9>"$lock_dir/update.lock"
if ! flock -n 9; then
  echo "Another RR harvest/import is already running." >&2
  exit 75
fi

harvest_args=()
case "${1:-}" in
  "")
    ;;
  --force-local)
    harvest_args=(--force-full 'ivo://fai.kz/%')
    shift
    ;;
  --force)
    test "$#" -eq 2 || {
      echo "Usage: $0 [--force-local | --force SQL_PATTERN | --force-full SQL_PATTERN]" >&2
      exit 64
    }
    harvest_args=(--force "$2")
    shift 2
    ;;
  --force-full)
    test "$#" -eq 2 || {
      echo "Usage: $0 [--force-local | --force SQL_PATTERN | --force-full SQL_PATTERN]" >&2
      exit 64
    }
    harvest_args=(--force-full "$2")
    shift 2
    ;;
  *)
    echo "Unknown argument: $1" >&2
    echo "Usage: $0 [--force-local | --force SQL_PATTERN | --force-full SQL_PATTERN]" >&2
    exit 64
    ;;
esac

test "$#" -eq 0 || {
  echo "Unexpected trailing arguments: $*" >&2
  exit 64
}

echo "[$(date --iso-8601=seconds)] Updating the IVOA Registry of Registries"
rofr_status=0
python3 bin/harvestRofR.py || rofr_status=$?

echo "[$(date --iso-8601=seconds)] Harvesting publishing registries"
python3 bin/harvestRegistries.py "${harvest_args[@]}"

echo "[$(date --iso-8601=seconds)] Importing new OAI records"
dachs imp -L q import

echo "[$(date --iso-8601=seconds)] Refreshing rr.tap_table"
dachs imp q make_tap_table

echo "[$(date --iso-8601=seconds)] RR update completed"
exit "$rofr_status"
