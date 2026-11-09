#!/usr/bin/env python3
"""Render a decision-card markdown stub from a corpus file's front-matter.

This is NOT the Grok Bot. Use it for offline scaffolding; fill judgment via Bot.
"""
from __future__ import annotations

import argparse
import re
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
TEMPLATE = Path(__file__).resolve().parent / "templates" / "decision-card.md"


def parse_front_matter(text: str) -> dict[str, str]:
    if not text.startswith("---"):
        return {}
    parts = text.split("---", 2)
    if len(parts) < 3:
        return {}
    meta: dict[str, str] = {}
    for line in parts[1].strip().splitlines():
        if ":" in line:
            k, v = line.split(":", 1)
            meta[k.strip()] = v.strip()
    return meta


def main() -> None:
    p = argparse.ArgumentParser()
    p.add_argument("--corpus", type=Path, required=True)
    p.add_argument(
        "--out",
        type=Path,
        default=None,
        help="default: alongside corpus with _decision-card suffix",
    )
    args = p.parse_args()

    raw = args.corpus.read_text(encoding="utf-8")
    meta = parse_front_matter(raw)
    title = meta.get("title", args.corpus.stem)
    doc_id = meta.get("id", args.corpus.stem)
    date = meta.get("date", "")

    tpl = TEMPLATE.read_text(encoding="utf-8")
    filled = (
        tpl.replace("{{title}}", title)
        .replace("{{corpus_id}}", doc_id)
        .replace("{{date}}", date)
    )
    # Mark stub sections
    filled += "\n---\n_stub: fill via Grok Bot; see corpus/examples for a completed sample._\n"

    out = args.out
    if out is None:
        out = args.corpus.with_name(args.corpus.stem + "_decision-card_STUB.md")
    out.write_text(filled, encoding="utf-8")
    print(f"wrote {out}")


if __name__ == "__main__":
    main()
