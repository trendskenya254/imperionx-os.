#!/usr/bin/env bash
set -euo pipefail
: "${DATABASE_URL:?Set DATABASE_URL to a PostgreSQL connection URL}"
case "$DATABASE_URL" in postgresql://*|postgresql+psycopg://*) ;; *) echo "DATABASE_URL must target PostgreSQL" >&2; exit 2;; esac
command -v pg_dump >/dev/null || { echo "pg_dump is required" >&2; exit 2; }
OUT_DIR="${BACKUP_DIR:-./backups}"
mkdir -p "$OUT_DIR"
chmod 700 "$OUT_DIR"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
OUT="$OUT_DIR/imperionx-$STAMP.dump"
umask 077
pg_dump --format=custom --no-owner --file "$OUT" "$DATABASE_URL"
echo "Backup created: $OUT"
echo "Record checksum: sha256sum '$OUT'"
