# IMPERIONX OS v4.0 — Universal Business Trust Graph & Network Intelligence

## Scope
- Explicit owner/admin opt-in for second-degree network discovery.
- Authenticated trust graph endpoint with depth 1 or 2 and bounded result size.
- Direct connections include factual verification status, active credential count and completed bilateral transaction count.
- Second-degree identities appear only when the business has a published profile and has explicitly enabled network discovery.
- Mutual connection identities and private relationship paths are not returned.
- No composite trust score; the graph exposes separate factual signals.
- Existing v3.9 network overview and business records are preserved.

## API
- `PUT /v1/business/network-discovery` with `{"enabled": true|false}`. Owner/admin role and MFA required. A published profile is required to enable discovery.
- `GET /v1/network/trust-graph?depth=1|2&limit=100`. Authenticated organization membership required; `limit` range 1–200.

## Migration
- `0023_universal_trust_graph`: adds `business_public_profiles.network_discoverable`, default false, with an index. Existing profiles remain undiscoverable until owners opt in.

## Safety boundaries
- Second-degree discovery never includes non-published or non-opted-in businesses.
- Direct edges are limited to accepted connections.
- No private email, phone, evidence references, comments, reviewer identities, or intermediary organization identities are exposed in second-degree results.
- This is factual network intelligence, not a credit rating or guarantee of business performance.
