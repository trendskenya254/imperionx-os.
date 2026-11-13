# IMPERIONX OS v4.1 — Universal Business Discovery & Matching

## Release objective

Make the Universal Business Network actionable through capability-based buyer, supplier and partner discovery, while preserving opt-in publication, tenant privacy and recipient-approved introductions.

## Delivered

- Extended business public profiles with `offers` and `seeks` lists (up to 30 labels each, 2–80 characters per label).
- Added authenticated `GET /v1/discovery/matches` with `find_suppliers`, `find_buyers` and `find_partners` directions.
- Matches are built only from explicitly published business profiles and the requesting organization's own profile preferences.
- Results include matching capability labels, concise reasons, and descriptive relevance (`strong` or `potential`); no composite trust score or endorsement is produced.
- Added industry, country, text, limit and offset filters.
- Match results omit public email and other contact fields. A separate connection request is required, and the recipient must approve it.
- Extended the business profile dashboard with offer/need fields and an opportunity matching panel.
- Added migration `0024_business_discovery_matching` and a composite published-profile index.

## API example

`GET /v1/discovery/matches?direction=find_suppliers&country_code=KE&limit=20`

The endpoint requires an authenticated organization session and a configured business profile. Add `offers`, `seeks` and `capabilities` to the profile using `PUT /v1/business/profile`.

## Matching semantics

- `find_suppliers`: compare the organization's needs/capabilities with candidate published offers/capabilities.
- `find_buyers`: compare the organization's offers/capabilities with candidate published needs/capabilities.
- `find_partners`: identify overlapping published capabilities, offers or needs.

The reasons are deterministic label overlaps plus optional same-country/same-industry context. Relevance labels are not trust ratings. The match endpoint does not create a connection, send a message, disclose private contact data, or guarantee commercial suitability.

## Privacy and safety

Only published profiles are eligible. Results contain public business identity and published matching fields; contact email is intentionally excluded. Introductions use the existing connection-request workflow. The receiving organization controls acceptance and selected profile sharing. No automated outreach is performed.

## Migration

`0024_business_discovery_matching` follows `0023_universal_trust_graph`. It adds non-null JSON `offers` and `seeks` columns with empty-list defaults and an index on published profiles.
