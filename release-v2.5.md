# IMPERIONX OS v2.5 — Universal Business Network Connections

## Delivered

1. Target-side accept/reject lifecycle for pending business connections.
2. Owner/admin authorization and audit records for every decision.
3. Explicit allow-listed profile sharing on accepted connections only.
4. Up to 20 public business capability labels, validated and searchable through existing discovery.
5. Referral records restricted to accepted connections and participating organizations.
6. Alembic migration `0012_business_network`.

## API

- `POST /v1/business/connections/{connection_id}/decision` — target owner/admin accepts or rejects; `shared_fields` may include `tagline`, `description`, `website_url`, `city`, `public_email`, `capabilities`.
- `GET /v1/business/connections` — connection state; requester sees only target fields explicitly shared by the target.
- `POST /v1/business/referrals` — records a referral over an accepted connection.
- `GET /v1/business/referrals` — records visible only to the two participating organizations.
- `PUT /v1/business/profile` — now accepts bounded `capabilities` labels.

## Safety boundaries

No customer PII, internal inquiries, sales records, or account details are shared. No automatic messages, payments, commissions, or external actions are triggered. Rejected/accepted requests cannot be re-decided. Verification badges are intentionally not issued: identity verification requires an actual evidence-review process.

## Verification

See the release verification report in the project handoff. SQLite migration and automated backend tests are covered; live PostgreSQL and production deployment are not certified by this release.
