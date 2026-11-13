#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() { echo "PREFLIGHT FAILED: $1" >&2; exit 1; }
[[ -f .env ]] || fail "Create .env from .env.example; never deploy with example values."
command -v docker >/dev/null 2>&1 || fail "Docker is required for Compose deployment."
docker compose version >/dev/null 2>&1 || fail "Docker Compose v2 is required."

# Read dotenv assignments without evaluating the file as shell code.
env_value() {
  local key="$1" value
  value="$(grep -E "^${key}=" .env | tail -n 1 | cut -d= -f2- || true)"
  value="${value%$'\\r'}"
  if [[ "$value" == \\\"*\\\" ]]; then value="${value#\\\"}"; value="${value%\\\"}"; fi
  if [[ "$value" == \'*\' ]]; then value="${value#\'}"; value="${value%\'}"; fi
  printf '%s' "$value"
}
APP_ENV="$(env_value APP_ENV)"
DATABASE_URL="$(env_value DATABASE_URL)"
PUBLIC_BASE_URL="$(env_value PUBLIC_BASE_URL)"
POSTGRES_PASSWORD="$(env_value POSTGRES_PASSWORD)"
MFA_ENCRYPTION_KEY="$(env_value MFA_ENCRYPTION_KEY)"
PUBLIC_RATE_LIMIT_HMAC_KEY="$(env_value PUBLIC_RATE_LIMIT_HMAC_KEY)"
WEBHOOK_WORKER_ENABLED="$(env_value WEBHOOK_WORKER_ENABLED)"
SMTP_HOST="$(env_value SMTP_HOST)"
SMTP_FROM_EMAIL="$(env_value SMTP_FROM_EMAIL)"

[[ "$APP_ENV" == "production" || "$APP_ENV" == "staging" ]] || fail "APP_ENV must be staging or production."
[[ "$DATABASE_URL" == postgresql://* || "$DATABASE_URL" == postgresql+psycopg://* ]] || fail "DATABASE_URL must target PostgreSQL."
[[ "$PUBLIC_BASE_URL" == https://* ]] || fail "PUBLIC_BASE_URL must use HTTPS for staging/production."
[[ -n "$POSTGRES_PASSWORD" && "$POSTGRES_PASSWORD" != "replace-this-password" ]] || fail "Replace POSTGRES_PASSWORD."
[[ -n "$MFA_ENCRYPTION_KEY" && "$MFA_ENCRYPTION_KEY" != "replace-this-password" ]] || fail "MFA_ENCRYPTION_KEY is required and must not be a placeholder."
[[ -n "$SMTP_HOST" ]] || fail "SMTP_HOST must be configured before pilot deployment."
[[ -n "$SMTP_FROM_EMAIL" && "$SMTP_FROM_EMAIL" == *@* && "$SMTP_FROM_EMAIL" != *.local ]] || fail "SMTP_FROM_EMAIL must be a deliverable email address."
if command -v stat >/dev/null 2>&1; then
  ENV_MODE="$(stat -c '%a' .env 2>/dev/null || true)"
  if [[ -n "$ENV_MODE" && "$ENV_MODE" =~ ^[0-7]{3,4}$ ]]; then
    ENV_PERMS=$((8#$ENV_MODE))
    (( (ENV_PERMS & 077) == 0 )) || fail ".env permissions are too broad; run chmod 600 .env."
  fi
fi
[[ ${#PUBLIC_RATE_LIMIT_HMAC_KEY} -ge 32 ]] || fail "PUBLIC_RATE_LIMIT_HMAC_KEY must contain at least 32 characters."
[[ "$WEBHOOK_WORKER_ENABLED" != "true" ]] || echo "WARNING: outbound webhook delivery is enabled; confirm receiver idempotency and egress policy."

docker compose config -q || fail "Docker Compose configuration is invalid."
echo "Preflight passed. This checks configuration only; it does not certify the host, secrets manager, TLS edge, or PostgreSQL runtime."
