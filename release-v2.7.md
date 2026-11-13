# IMPERIONX OS v2.7 — Universal Business Trust & Transaction Readiness

## Delivered

- Evidence-based business verification submissions with pending/verified/rejected states.
- Platform review endpoints are deny-by-default and require the reviewing user ID to be explicitly allowlisted in `IMPERIONX_PLATFORM_REVIEWER_USER_IDS`.
- Verification decisions are audited against the applicant organization. No public verified badge is inferred from self-asserted information.
- Purchase requests can be created only between organizations with an accepted business connection.
- The connected supplier can submit priced quotes in integer minor currency units; the buyer can view and accept a quote.
- Quote acceptance creates a transaction record. Supplier can mark it in progress; buyer confirms completion; either party can cancel before closure.
- Tenant-scoped transaction, quote and request views.
- IMPERIONX OS does not process payments, escrow funds, or represent that funds were transferred.

## Configuration

Set `IMPERIONX_PLATFORM_REVIEWER_USER_IDS` to a comma-separated list of explicitly provisioned platform reviewer user IDs. Leave it unset until platform reviewer accounts and operating controls exist; all review routes then return 403. This is an initial allowlist control, not a complete platform-admin identity lifecycle.

## API

- `POST/GET /v1/business/verification`
- `GET /v1/platform/verifications`
- `POST /v1/platform/verifications/{organization_id}/decision`
- `POST/GET /v1/business/purchase-requests`
- `POST /v1/business/purchase-requests/{request_id}/quotes`
- `GET /v1/business/quotes`
- `POST /v1/business/quotes/{quote_id}/accept`
- `GET /v1/business/transactions`
- `PATCH /v1/business/transactions/{transaction_id}/status`

## Limitations

Evidence references are metadata only; secure document upload, malware scanning, retention, reviewer separation-of-duties and appeals are not implemented. Verification is not a legal guarantee. Quotes and transactions are records of commercial intent, not payment or contract execution. Live PostgreSQL, frontend production build, Docker deployment and independent security review must be verified before production use.
