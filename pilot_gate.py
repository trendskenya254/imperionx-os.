#!/usr/bin/env python3
"""Evidence-oriented staging and pilot gate for IMPERIONX OS v4.8.

Runs only non-destructive checks. It never deploys, migrates, sends email,
changes data, or enables outbound integrations.
"""
from __future__ import annotations
import json
import os
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REQUIRED = {
    "STAGING_BASE_URL": "HTTPS staging base URL",
    "APPROVED_STAGING_OWNER": "named staging operator",
    "INCIDENT_CONTACT": "incident contact",
    "BACKUP_OFFSITE_URI": "off-host backup destination reference",
    "RESTORE_DRILL_EVIDENCE": "isolated restore-drill evidence reference",
    "SECURITY_REVIEW_EVIDENCE": "security review evidence reference",
}

def main() -> int:
    report = {"release": "5.0.0", "mode": "non_destructive", "checks": [], "missing_evidence": []}
    base = os.getenv("STAGING_BASE_URL", "").strip()
    if not base.startswith("https://"):
        report["checks"].append({"name": "staging_url", "status": "fail", "detail": "STAGING_BASE_URL must use HTTPS"})
    else:
        report["checks"].append({"name": "staging_url", "status": "pass"})
    smoke = subprocess.run([sys.executable, str(ROOT / "scripts" / "staging_smoke.py")], cwd=ROOT, capture_output=True, text=True, env=os.environ.copy()) if base.startswith("https://") else None
    if smoke:
        report["checks"].append({"name": "live_health_and_readiness", "status": "pass" if smoke.returncode == 0 else "fail", "detail": (smoke.stdout + smoke.stderr).strip()[-2000:]})
    for key, description in REQUIRED.items():
        value = os.getenv(key, "").strip()
        if not value:
            report["missing_evidence"].append({"field": key, "required": description})
    report["checks"].append({"name": "external_evidence", "status": "pass" if not report["missing_evidence"] else "incomplete", "detail": "Evidence references are recorded, not independently validated by this script."})
    report["overall"] = "pass" if all(c["status"] == "pass" for c in report["checks"]) and not report["missing_evidence"] else "not_ready"
    print(json.dumps(report, indent=2))
    return 0 if report["overall"] == "pass" else 1

if __name__ == "__main__":
    raise SystemExit(main())
