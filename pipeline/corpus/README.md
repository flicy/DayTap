# Stage 3 — Corpus normalize

**职责**：把转写 txt 收成带 front-matter 的 Markdown，写入仓库级 `corpus/`（示例）或本机 `corpus/daily/`（真实，已 gitignore）。

## 约定

```markdown
---
id: 2026-11-03_sample-meeting
date: 2026-11-03
title: …
source: dedao | manual | other
devices: [iphone]
people: [崔莹, Anatole]
tags: [watch, personal-agent]
---

## 转写

…
```

## 脚本

`normalize_stub.py` — 最小转换；不做说话人分离增强。
