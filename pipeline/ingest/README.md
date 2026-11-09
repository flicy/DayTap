# Stage 1 — Ingest

**职责**：把「当天的录音」登记进流水线，不在这里做 ASR。

## 目录

- `inbox/YYYY-MM-DD/` — 当日待处理（git 忽略音频，可留 `.gitkeep`）
- `raw/` — 可选归档位（同样忽略媒体文件）
- `register_take.py` — 写一条 JSON 元数据

## 元数据字段（最小集）

```json
{
  "id": "2026-11-03_iphone_001",
  "date": "2026-11-03",
  "title": "产品群讨论-Watch录音",
  "device": "iphone",
  "role": "primary",
  "audio_path": "(local only)",
  "consent_noted": true,
  "notes": "按需录；Watch 未开 backup"
}
```

`device`: `iphone` | `daytap-watch`（旧值 `watch` 仍接受）  
`role`: `wrist` | `phone-fallback`（旧值 `primary` | `backup` 仍接受）

## DayTap Watch App

腕上录音由 `apps/DayTap` 的手表 App 完成，经 WatchConnectivity 传到 iPhone 的 DayTap。人工把那条 m4a 的本地路径登记进当日 `inbox/` 时用：

```bash
python3 pipeline/ingest/register_take.py --title "私教" --device daytap-watch --role wrist --consent --audio-path "/path/on/iphone-or-mac"
```

`role=wrist` 表示 Track 1/2 的腕上麦。Track 0 手机保底用 `--device iphone --role phone-fallback`。本脚本仍只写 JSON，不搬音频。真机传输是否稳定：**待验证**。
