# IMPERIONX OS v4.2 — Universal Opportunity & Deal Pipeline

## Purpose
Connect business discovery and accepted business relationships to a controlled commercial workflow, while preserving tenant boundaries and keeping funds outside the platform.

## Delivered
- Buyer can close an open purchase request; only the buyer organization can do so.
- Closing a request rejects its still-submitted quote(s) and emits `commerce.purchase_request.closed` for subscribed integrations.
- Supplier can withdraw its own submitted quote.
- Buyer can reject a submitted quote on an open request.
- Quote acceptance enforces its validity window and rejects competing submitted quotes.
- Quote decisions and request closure are audited.
- Existing transaction state transitions, supplier fulfillment events, buyer-confirmed completion, disputes and reputation remain connected to the deal lifecycle.
- No payment custody, escrow, or funds transfer is introduced.

## Main workflow
1. Establish an accepted business connection.
2. Buyer creates a purchase request.
3. Supplier submits a priced quote with currency, terms and validity.
4. Buyer reviews, rejects, or accepts; supplier may withdraw before decision.
5. Accepted quote creates a transaction; supplier advances fulfilment and buyer confirms completion.

## API additions
- `POST /v1/business/purchase-requests/{request_id}/close`
- `POST /v1/business/quotes/{quote_id}/decision` with `decision=reject|withdraw`
- Existing quote acceptance now enforces expiry and closes competing submitted proposals.

## Operational note
This is an engineering release. A passing local test suite is not equivalent to production deployment or external security certification.
