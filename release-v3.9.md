# IMPERIONX OS v3.9 — Reputation Integrity & Dispute Resolution

## Delivered
- Feedback challenges available only to either organization participating in the transaction-linked feedback.
- Structured challenge reasons, explanation, optional evidence reference, and optional SHA-256 evidence digest. Evidence files are not uploaded or hosted by this service.
- Feedback is excluded from public reputation aggregates while under review and when a challenge is upheld. Rejected challenges restore publication.
- Platform moderation queue and decision endpoint; reviewers who belong to either transaction organization are blocked from adjudicating.
- One appeal per resolved challenge, with a separate platform appeal queue and independent membership-conflict check. An overturned decision reverses the feedback visibility outcome.
- Audit events for challenge submission, moderation decisions, appeals, and appeal decisions. Original feedback is retained; moderation changes visibility rather than deleting content.
- Public reputation still exposes dimension averages only, without comments, reviewer identities, or a composite score.

## API
- `POST /v1/business/feedback/{feedback_id}/challenge`
- `GET /v1/platform/feedback-challenges`
- `POST /v1/platform/feedback-challenges/{challenge_id}/decision`
- `POST /v1/business/feedback-challenges/{challenge_id}/appeal`
- `GET /v1/platform/feedback-appeals`
- `POST /v1/platform/feedback-appeals/{challenge_id}/decision`

## Important boundaries
Evidence references and digests are metadata, not proof that a referenced file exists or is authentic. Reviewers must verify evidence through approved processes. This release does not provide automated fake-review detection, file storage, legal arbitration, or an external appeal body.
