#!/usr/bin/env bash
set -euo pipefail
: "${TEST_DATABASE_URL:?Set TEST_DATABASE_URL to a disposable PostgreSQL test database URL}"
case "$TEST_DATABASE_URL" in
  postgresql://*) TEST_DATABASE_URL="${TEST_DATABASE_URL/postgresql:\/\//postgresql+psycopg:\/\/}" ;;
  postgresql+psycopg://*) ;;
  *) echo "TEST_DATABASE_URL must target PostgreSQL" >&2; exit 2 ;;
esac
export TEST_DATABASE_URL
export DATABASE_URL="$TEST_DATABASE_URL"
cd backend
PYTHONPATH=. alembic upgrade head
PYTHONPATH=. python -m pytest -q tests
cd ..
python scripts/test_postgres_multiworker.py
