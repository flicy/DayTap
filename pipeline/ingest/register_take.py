#!/usr/bin/env python3
"""Register a recording take into pipeline/ingest/inbox/YYYY-MM-DD/ as JSON metadata.

Does not move or upload audio. Audio stays local (gitignored).
"""
from __future__ import annotations

import argparse
import json
from datetime import datetime
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
INBOX = Path(__file__).resolve().parent / "inbox"


def main() -> None:
    p = argparse.ArgumentParser(description="Register an ingest take (metadata only)")
    p.add_argument("--title", required=True)
    p.add_argument(
        "--device",
        choices=("iphone", "daytap-watch", "watch"),
        default="iphone",
        help="iphone = Track 0 phone; daytap-watch = DayTap Watch App; watch = legacy alias",
    )
    p.add_argument(
        "--role",
        choices=("wrist", "phone-fallback", "primary", "backup"),
        default="primary",
        help="wrist = Track 1/2 DayTap mic; phone-fallback = Track 0; primary/backup = legacy",
    )
    p.add_argument("--date", default=None, help="YYYY-MM-DD (default: today local)")
    p.add_argument("--audio-path", default="", help="Local path pointer (not committed)")
    p.add_argument("--notes", default="")
    p.add_argument("--consent", action="store_true", help="Mark consent_noted=true")
    args = p.parse_args()

    day = args.date or datetime.now().strftime("%Y-%m-%d")
    day_dir = INBOX / day
    day_dir.mkdir(parents=True, exist_ok=True)

    existing = list(day_dir.glob(f"{day}_{args.device}_*.json"))
    seq = len(existing) + 1
    take_id = f"{day}_{args.device}_{seq:03d}"
    payload = {
        "id": take_id,
        "date": day,
        "title": args.title,
        "device": args.device,
        "role": args.role,
        "audio_path": args.audio_path or "(local only)",
        "consent_noted": bool(args.consent),
        "notes": args.notes,
        "registered_at": datetime.now().isoformat(timespec="seconds"),
    }
    out = day_dir / f"{take_id}.json"
    out.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"wrote {out}")


if __name__ == "__main__":
    main()
