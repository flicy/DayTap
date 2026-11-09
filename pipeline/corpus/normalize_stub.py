#!/usr/bin/env python3
"""Normalize a plain transcript .txt into corpus Markdown with YAML front-matter."""
from __future__ import annotations

import argparse
from datetime import datetime
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]


def main() -> None:
    p = argparse.ArgumentParser()
    p.add_argument("--transcript", type=Path, required=True)
    p.add_argument("--slug", required=True, help="short slug, e.g. sample-meeting")
    p.add_argument("--date", default=None)
    p.add_argument("--title", default=None)
    p.add_argument("--source", default="manual", choices=("manual", "dedao", "other"))
    p.add_argument(
        "--out-dir",
        type=Path,
        default=REPO / "corpus" / "examples",
        help="default: corpus/examples (use corpus/daily for private)",
    )
    args = p.parse_args()

    text = args.transcript.read_text(encoding="utf-8").strip() + "\n"
    day = args.date or datetime.now().strftime("%Y-%m-%d")
    doc_id = f"{day}_{args.slug}"
    title = args.title or args.slug.replace("-", " ")
    out_dir = args.out_dir
    out_dir.mkdir(parents=True, exist_ok=True)
    out = out_dir / f"{doc_id}.md"

    body = f"""---
id: {doc_id}
date: {day}
title: {title}
source: {args.source}
devices: [iphone]
people: []
tags: [personal-agent]
---

## 转写

{text}
"""
    out.write_text(body, encoding="utf-8")
    print(f"wrote {out}")


if __name__ == "__main__":
    main()
