#!/usr/bin/env bash
set -euo pipefail
: "${BACKUP_FILE:?Set BACKUP_FILE to a custom-format pg_dump backup}"
command -v pg_restore >/dev/null || { echo "pg_restore is required" >&2; exit 2; }
command -v sha256sum >/dev/null || { echo "sha256sum is required" >&2; exit 2; }
[[ -f "$BACKUP_FILE" ]] || { echo "Backup file not found" >&2; exit 2; }
[[ -s "$BACKUP_FILE" ]] || { echo "Backup file is empty" >&2; exit 2; }
# Listing validates the archive structure without modifying any database.
pg_restore --list "$BACKUP_FILE" >/dev/null
echo "PASS: backup archive structure is readable"
sha256sum "$BACKUP_FILE"
echo "NOTE: archive readability is not proof of recoverability; restore into an isolated disposable database and run smoke tests."
