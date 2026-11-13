# IMPERIONX OS v2.8 — Universal Commerce Experience

## Release scope

v2.8 brings the v2.7 trust and commerce APIs into the authenticated Next.js workspace. It is a frontend experience release; no backend schema or endpoint changes are included.

### Business verification workspace
- Displays the organization's verification status and reviewer note.
- Allows owners/administrators to submit evidence type, a reference/registry URL, and an applicant note.
- Makes clear that submission is not verification and that pending evidence requires independent platform review.
- Does not invite users to paste sensitive document numbers or upload confidential files to public URLs.

### Buyer and supplier workspace
- Create purchase requests through accepted business connections.
- List purchase requests where the active organization is buyer or supplier.
- Suppliers can prepare quotations with amount, currency, terms, and validity period.
- Buyers can accept submitted quotations for their own open requests.
- Track transactions and show role-appropriate actions: supplier starts work; buyer confirms completion; either party can cancel before closure.
- The UI explicitly states that a transaction record is not a payment, escrow, or proof of funds transfer.

## Security and authorization

The interface uses the existing same-origin authenticated BFF and organization-scoped API. Backend authorization remains authoritative. Purchase requests require accepted connections; quotation acceptance is buyer-only; transaction transitions are role-restricted by the backend. No card/bank details, payment processing, escrow, or fund custody are introduced.

## Verification

- Backend regression suite: 67 passed.
- Frontend TSX transpilation: passed (syntax/transformation check only).
- Frontend package and TypeScript JSON manifests: valid.
- Frontend production build and full static type-check: not verified because dependencies are not installed in this environment.
- Live PostgreSQL, Docker startup, browser end-to-end tests, and production deployment: not verified.

## Known limitations

- Evidence is submitted as a reference/URL; secure document upload, malware scanning, and private evidence storage are not part of this release.
- Payment-provider integrations are deferred until licensed provider selection, compliance review, and reconciliation design are complete.
- The existing API transaction lifecycle is operational recordkeeping, not legal contract generation, delivery verification, escrow, or payment confirmation.
