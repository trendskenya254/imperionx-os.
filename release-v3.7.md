# IMPERIONX OS v3.7 — Universal Business Identity & Trust

## Delivered scope
- Extends the existing organization verification workflow with tenant-scoped evidence metadata, issuer provenance, expiry and access-scope fields.
- Stores access-controlled evidence references only; document bytes are not uploaded or served by this release.
- Issues platform HMAC-SHA256 trust credentials only to allowlisted platform reviewers with MFA, after organization verification, and only when a 32+ character signing key is configured.
- Supports credential expiry and explicit revocation with audit events.
- Exposes a privacy-safe trust summary only across an accepted business connection. Evidence references and reviewer-only details are never included.
- Uses factual verification status and credential claims; it does not calculate a predictive or composite trust score.

## API surface
- `POST /v1/business/verification/evidence`
- `GET /v1/business/verification/evidence`
- `GET /v1/platform/verifications/{organization_id}/evidence` (MFA-protected reviewer access)
- `POST /v1/platform/verifications/{organization_id}/credentials`
- `POST /v1/platform/trust-credentials/{credential_id}/revoke`
- `GET /v1/network/organizations/{organization_id}/trust`

## Configuration and operational boundaries
Set `PUBLIC_RATE_LIMIT_HMAC_KEY` to a random secret of at least 32 characters before issuing credentials. Existing signatures depend on this shared key; rotate only with a planned key-version migration and re-issuance strategy.

This is an internal platform review workflow, not government registry validation, regulatory KYC/AML certification, or legal identity assurance. Evidence references must point to a separately secured document vault. HMAC credentials are verifiable only by services holding the shared secret; they are not public-key or third-party verifiable credentials.
