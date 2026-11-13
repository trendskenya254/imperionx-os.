# IMPERIONX OS v2.9 — Universal Commerce Intelligence

## Scope delivered

1. Commerce insights endpoint: `GET /v1/business/commerce/insights?days=90` returns buyer and supplier aggregates, transaction volumes grouped by currency, completion/cancellation/in-progress counts, and open dispute count. It performs no FX conversion.
2. Supplier fulfillment timeline: `POST /v1/business/transactions/{id}/fulfillment` records ordered `prepared`, `dispatched`, and `delivered` milestones. Only the supplier can write; either transaction party can read.
3. Dispute workflow: participants can open a dispute on an accepted or in-progress transaction. One open dispute is allowed per transaction. Both participants can view it.
4. Platform adjudication: allowlisted platform reviewers with MFA can review open disputes, but cannot adjudicate disputes involving an organization they belong to. Decisions and notes are audited.
5. Transaction closure guard: an open dispute blocks completion or cancellation until platform review is recorded.
6. Dashboard: adds commerce metrics, supplier fulfillment milestone controls, and dispute submission/history.

## New endpoints

- `GET /v1/business/commerce/insights?days=90`
- `POST /v1/business/transactions/{transaction_id}/fulfillment`
- `GET /v1/business/transactions/{transaction_id}/fulfillment`
- `POST /v1/business/transactions/{transaction_id}/disputes`
- `GET /v1/business/disputes`
- `GET /v1/platform/disputes`
- `POST /v1/platform/disputes/{dispute_id}/decision`

## Migration

- Revision: `0015_commerce_intelligence`
- Parent: `0014_trust_commerce`
- Adds `business_fulfillment_events` and `business_disputes`.

## Explicit non-goals

No payment processing, escrow, funds custody, supplier payout, FX conversion, automatic shipping-provider integration, or automatic dispute adjudication is implemented.
