# IMPERIONX OS v2.4 — Business Discovery & Customer Acquisition

## Scope

This release adds an API foundation for opt-in public business discovery and permission-based business connectivity.

- Owners/admins can configure a public business profile. It remains private until `is_published: true` is explicitly set.
- Public discovery returns only published profile fields; organization membership, internal notes, customer records and other tenant data are never included.
- Public lead capture requires explicit `consent_to_contact: true`. Contact details are only available to authenticated members of the destination organization.
- Authenticated organizations can request a connection with another published business. Requests begin in `pending` state; no automatic acceptance, data sharing, messaging or commercial commitment occurs.

## API

- `PUT /v1/business/profile` — owner/admin configure or publish a profile.
- `GET /v1/business/profile` — authenticated organization reads its profile.
- `GET /v1/discovery/businesses?q=&industry=&country_code=&limit=&offset=` — public directory search.
- `GET /v1/discovery/businesses/{slug}` — public profile detail.
- `POST /v1/discovery/businesses/{slug}/leads` — public lead submission with mandatory consent.
- `GET /v1/business/leads` — authenticated organization's private leads.
- `POST /v1/business/connections` and `GET /v1/business/connections` — request/list organization connections.

## Data migration

Alembic revision `0011_business_discovery` follows `0010_pilot_management`.

## Safety and limitations

- Profile publication is opt-in and can be disabled by updating `is_published` to false.
- Public email is deliberately opt-in; no private account email is exposed by default.
- Leads are not automatically converted to internal inquiries or sent by email in this release.
- Connection requests are pending records only; approval/rejection lifecycle and notification delivery are future work.
- Public endpoints need edge rate limiting, bot protection, abuse monitoring, privacy notice/retention policy and production security review before open internet launch.
- This release is an API foundation; no claim of completed public website UX, live email, PostgreSQL deployment or production readiness is made.
