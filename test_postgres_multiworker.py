#!/usr/bin/env python3
"""Disposable-PostgreSQL concurrency proof for SKIP LOCKED webhook claims.

Run only against a disposable database after `alembic upgrade head`:
  TEST_DATABASE_URL='postgresql+psycopg://...' python scripts/test_postgres_multiworker.py
"""
from __future__ import annotations

import multiprocessing as mp
import os
import sys
import time
import uuid
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "backend"))
url = os.environ.get("TEST_DATABASE_URL", "")
if url.startswith("postgresql://"):
    url = url.replace("postgresql://", "postgresql+psycopg://", 1)
if not url.startswith("postgresql+psycopg://"):
    raise SystemExit("TEST_DATABASE_URL must be a disposable PostgreSQL URL (postgresql+psycopg://...) ")
os.environ["DATABASE_URL"] = url


def _claim_until_empty(_worker_number: int) -> list[str]:
    from sqlalchemy import func, select
    from app.db import SessionLocal
    from app.models import WebhookDelivery
    from app.webhook_delivery import _claim_one

    claimed: list[str] = []
    deadline = time.monotonic() + 90
    with SessionLocal() as session:
        while time.monotonic() < deadline:
            delivery_id = _claim_one(session, datetime.now(timezone.utc))
            if delivery_id:
                claimed.append(delivery_id)
                continue
            pending = session.scalar(select(func.count()).select_from(WebhookDelivery).where(WebhookDelivery.status == "queued")) or 0
            if pending == 0:
                return claimed
            time.sleep(0.05)
    raise TimeoutError("worker timed out while queued test deliveries remained")


def main() -> None:
    from sqlalchemy import delete
    from sqlalchemy.orm import Session
    from app.db import engine
    from app.models import Organization, User, WebhookSubscription, WebhookDelivery

    run_id = uuid.uuid4().hex
    org = Organization(name=f"v35-multiworker-{run_id}")
    user = User(email=f"v35-{run_id}@example.invalid", full_name="Concurrency Test", password_hash="not-a-login-credential")
    with Session(engine) as session:
        session.add_all([org, user])
        session.flush()
        subscription = WebhookSubscription(
            organization_id=org.id, name="Concurrency test sink", endpoint_url="https://example.invalid/webhook",
            events=["test.concurrent"], secret_encrypted="not-used-by-claim-test", created_by_user_id=user.id,
        )
        session.add(subscription)
        session.flush()
        expected = set()
        for index in range(100):
            row = WebhookDelivery(
                subscription_id=subscription.id, organization_id=org.id, event_type="test.concurrent",
                idempotency_key=f"{run_id}-{index}", payload={"test": True, "index": index}, signature="test",
                status="queued", attempts=0,
            )
            session.add(row)
            session.flush()
            expected.add(row.id)
        session.commit()
        subscription_id, organization_id, user_id = subscription.id, org.id, user.id

    try:
        ctx = mp.get_context("spawn")
        with ctx.Pool(processes=8) as pool:
            results = pool.map(_claim_until_empty, range(8))
        flattened = [item for batch in results for item in batch]
        unique = set(flattened)
        if len(flattened) != 100 or unique != expected:
            raise AssertionError(f"expected 100 unique claims; got {len(flattened)} claims / {len(unique)} unique")
        print("PASS: 8 independent PostgreSQL workers claimed 100 queued events exactly once concurrently.")
    finally:
        with Session(engine) as session:
            session.execute(delete(WebhookDelivery).where(WebhookDelivery.subscription_id == subscription_id))
            session.execute(delete(WebhookSubscription).where(WebhookSubscription.id == subscription_id))
            session.execute(delete(User).where(User.id == user_id))
            session.execute(delete(Organization).where(Organization.id == organization_id))
            session.commit()
        engine.dispose()


if __name__ == "__main__":
    main()
