# IMPERIONX OS v4.4 — Universal Business Intelligence & Decision Engine

## Release objective
Turn recorded commercial activity into explainable operational priorities without introducing autonomous external actions or unsupported predictive claims.

## Delivered
- Added authenticated `GET /v1/intelligence/commerce-decisions` for tenant-scoped commercial decision intelligence.
- Flags open buyer purchase requests with no submitted quotation after 72 hours.
- Flags supplier-side open requests without a supplier quotation after 72 hours.
- Flags submitted buyer quotations awaiting a decision after 48 hours.
- Flags accepted/in-progress transactions with no recorded status update after 72 hours.
- Provides transparent evidence, age in hours, priority and recommended next action for every item.
- Reports active/stale deal counts and supplier quotation response-time samples/average.
- Added the decision intelligence panel to the v4.4 business command center.
- Preserved v4.3 opportunity, quote, transaction, fulfilment and dispute workflows.
- No new database migration; existing records and migration head are unchanged.

## Decision and safety boundaries
- All analysis is derived from recorded request, quote and transaction timestamps.
- Supplier response time measures elapsed time from purchase request creation to quote creation; it is not a service-level guarantee.
- A stale transaction means no status update was recorded; it does not prove that work has stopped.
- Recommendations do not contact counterparties, send messages, accept/reject quotes, change records, initiate payments or hold funds.
- Currency values are not combined or converted.
- No black-box AI prediction is claimed.
