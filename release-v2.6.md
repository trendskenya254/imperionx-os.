# IMPERIONX OS v2.6 — Universal Business Network Interface

## Delivered

- Authenticated workspace interface for business profile creation, editing and explicit publication.
- Published-business directory search with industry-neutral capability tags.
- Incoming and outgoing connection management, including accept/reject controls for authorized owners and administrators.
- Referral recording and listing for accepted business connections.
- Clear unverified status language: the platform does not award verification badges or imply independent identity checks.
- Public lead submission throttling: five successful submissions per client/profile per 15-minute window; stores only an HMAC-SHA256 digest of client address plus profile slug, never the raw address; production requires `PUBLIC_RATE_LIMIT_HMAC_KEY` (at least 32 characters); expired limiter rows are cleaned during subsequent submissions.
- Optional trusted-proxy handling through `IMPERIONX_TRUSTED_PROXY_IPS`. Only when the immediate client is in this explicit allowlist is the first `X-Forwarded-For` address considered. Do not populate this allowlist with broad or untrusted ranges.

## Safety and limitations

- Public directory profiles are opt-in. Public lead capture still requires explicit consent.
- Connection acceptance does not grant broad tenant access; only explicitly selected profile fields are exposed.
- Referral records are operational records only; no commission, payment, external notification or automated commercial commitment occurs.
- Application-level lead throttling is defense-in-depth, not a replacement for edge/WAF rate limits, bot detection, abuse monitoring, and database concurrency testing. The database limiter is intended for a controlled pilot, not a public high-volume launch.
- Business verification workflow is intentionally not represented as complete. A trustworthy verification badge requires a separate platform-operator identity, evidence intake, reviewer permissions, decision audit, expiry/revocation and appeal controls. No business is marked verified in this release.
- Live PostgreSQL, production frontend build, Docker startup, edge protections and independent security review remain unverified.

## Verification

See `docs/verification-v2.6.md` for commands and results.
