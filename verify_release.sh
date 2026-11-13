#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

printf '\n== IMPERIONX OS release verification ==\n'
python --version
node --version 2>/dev/null || true

printf '\n[1/6] Python compilation\n'
python -m compileall -q backend/app backend/migrations backend/tests

printf '\n[2/6] Backend unit/API tests (SQLite test fixtures)\n'
PYTHONPATH=backend python -m pytest -q backend/tests

printf '\n[3/6] Fresh SQLite migration chain\n'
TMP_DB="$(mktemp /tmp/imperionx-release-XXXXXX.db)"
trap 'rm -f "$TMP_DB"' EXIT
(
  cd backend
  DATABASE_URL="sqlite:///$TMP_DB" PYTHONPATH=. alembic upgrade head
  DATABASE_URL="sqlite:///$TMP_DB" PYTHONPATH=. alembic current
)

printf '\n[4/6] Frontend manifest and TypeScript configuration JSON\n'
node -e "JSON.parse(require('fs').readFileSync('frontend/package.json','utf8')); JSON.parse(require('fs').readFileSync('frontend/tsconfig.json','utf8')); console.log('Frontend manifests valid')"

printf '\n[5/6] Optional frontend production build\n'
if [[ "${VERIFY_FRONTEND:-0}" == "1" ]]; then
  if [[ ! -d frontend/node_modules ]]; then
    (cd frontend && npm install --no-audit --no-fund)
  fi
  (cd frontend && npm run build)
else
  echo 'SKIPPED: set VERIFY_FRONTEND=1 in an environment with npm registry access.'
fi

printf '\n[6/6] Optional PostgreSQL integration suite\n'
if [[ -n "${TEST_DATABASE_URL:-}" ]]; then
  scripts/test_postgres.sh
else
  echo 'SKIPPED: set TEST_DATABASE_URL to a disposable PostgreSQL database.'
fi

if command -v docker >/dev/null 2>&1; then
  docker compose config -q
  echo 'Docker Compose configuration valid.'
else
  echo 'SKIPPED: Docker is not installed; container startup is unverified.'
fi

printf '\nVerification finished. Review every SKIPPED item before production deployment.\n'
