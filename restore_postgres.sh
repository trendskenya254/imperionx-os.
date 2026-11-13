#!/usr/bin/env bash
set -euo pipefail
: "${DATABASE_URL:?Set DATABASE_URL to the PostgreSQL restore target}"
: "${BACKUP_FILE:?Set BACKUP_FILE to a verified custom-format pg_dump file}"
if [[ "${CONFIRM_RESTORE:-}" != "YES" ]]; then
  echo "Refusing restore. Set CONFIRM_RESTORE=YES after verifying target and backup." >&2
  exit 2
fi
case "$DATABASE_URL" in postgresql://*|postgresql+psycopg://*) ;; *) echo "DATABASE_URL must target PostgreSQL" >&2; exit 2;; esac
[[ -f "$BACKUP_FILE" ]] || { echo "Backup file not found" >&2; exit 2; }
command -v pg_restore >/dev/null || { echo "pg_restore is required" >&2; exit 2; }
pg_restore --clean --if-exists --no-owner --exit-on-error --dbname "$DATABASE_URL" "$BACKUP_FILE"
echo "Restore command completed. Run application smoke tests before reopening traffic."
