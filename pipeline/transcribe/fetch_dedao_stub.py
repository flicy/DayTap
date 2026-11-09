#!/usr/bin/env python3
"""Skeleton for Dedao (得到大脑) OpenAPI note list.

- Does NOT ship API keys.
- Does NOT claim transcript download is fully verified.
- Official docs: https://www.biji.com/openapi

Set env (local only):
  DEDAO_CLIENT_ID=cli_xxx
  DEDAO_API_KEY=gk_live_xxx

Usage:
  python fetch_dedao_stub.py --dry-run
  python fetch_dedao_stub.py --list   # real HTTP; needs creds
"""
from __future__ import annotations

import argparse
import json
import os
import sys
import urllib.error
import urllib.request

BASE = "https://openapi.biji.com/open/api/v1"
LIST_PATH = "/resource/note/list"


def list_notes(client_id: str, api_key: str) -> dict:
    url = BASE + LIST_PATH
    req = urllib.request.Request(
        url,
        headers={
            "X-Client-ID": client_id,
            "Authorization": api_key,  # docs: no Bearer prefix
        },
        method="GET",
    )
    with urllib.request.urlopen(req, timeout=60) as resp:
        return json.loads(resp.read().decode("utf-8"))


def main() -> None:
    p = argparse.ArgumentParser()
    p.add_argument("--dry-run", action="store_true", help="Print plan only")
    p.add_argument("--list", action="store_true", help="Call note list API")
    args = p.parse_args()

    client_id = os.environ.get("DEDAO_CLIENT_ID", "")
    api_key = os.environ.get("DEDAO_API_KEY", "")

    if args.dry_run or not args.list:
        print("Dedao OpenAPI stub")
        print(f"  GET {BASE}{LIST_PATH}")
        print("  Headers: X-Client-ID, Authorization (gk_live_…)")
        print("  Transcript fetch: 待验证 — extend after confirming official fields")
        print(f"  Creds present: client_id={bool(client_id)} api_key={bool(api_key)}")
        if not args.list:
            return

    if not client_id or not api_key:
        print("Missing DEDAO_CLIENT_ID or DEDAO_API_KEY", file=sys.stderr)
        sys.exit(1)

    try:
        data = list_notes(client_id, api_key)
    except urllib.error.HTTPError as e:
        print(f"HTTP {e.code}: {e.read()[:500]!r}", file=sys.stderr)
        sys.exit(2)

    print(json.dumps(data, ensure_ascii=False, indent=2)[:4000])


if __name__ == "__main__":
    main()
