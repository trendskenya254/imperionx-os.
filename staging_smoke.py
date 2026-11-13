#!/usr/bin/env python3
"""Non-destructive staging smoke checks for IMPERIONX OS v5.0.

Usage: STAGING_BASE_URL=https://staging.example.com python scripts/staging_smoke.py
Only GETs /health and /ready. Does not print credentials or response headers.
"""
from __future__ import annotations
import json
import os
import sys
import urllib.error
import urllib.request

EXPECTED_VERSION = "5.0.0"
TIMEOUT_SECONDS = 5


def check(base_url: str, path: str) -> dict:
    url = base_url.rstrip("/") + path
    request = urllib.request.Request(url, headers={"Accept": "application/json", "User-Agent": "imperionx-staging-smoke/5.0"})
    try:
        with urllib.request.urlopen(request, timeout=TIMEOUT_SECONDS) as response:
            if response.status != 200:
                raise RuntimeError(f"{path} returned HTTP {response.status}")
            payload = json.loads(response.read(64 * 1024).decode("utf-8"))
    except (urllib.error.URLError, TimeoutError, ValueError) as exc:
        raise RuntimeError(f"{path} check failed: {type(exc).__name__}") from None
    if payload.get("version") != EXPECTED_VERSION:
        raise RuntimeError(f"{path} reported unexpected API version")
    expected_status = "ready" if path == "/ready" else "ok"
    if payload.get("status") != expected_status:
        raise RuntimeError(f"{path} reported an unexpected service status")
    return payload


def main() -> int:
    base_url = os.environ.get("STAGING_BASE_URL", "").strip()
    if not base_url.startswith("https://"):
        print("FAIL: STAGING_BASE_URL must use HTTPS", file=sys.stderr)
        return 2
    try:
        check(base_url, "/health")
        print("PASS: HTTPS liveness endpoint")
        check(base_url, "/ready")
        print("PASS: HTTPS readiness and database connectivity")
    except RuntimeError as exc:
        print(f"FAIL: {exc}", file=sys.stderr)
        return 1
    print("PASS: staging smoke checks completed; this is not a full security or load certification")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
