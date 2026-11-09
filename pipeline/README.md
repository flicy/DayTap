# Pipeline overview

四段式流水线。每段只做一件事；音频默认不进 Git。

| Stage | Dir | Input | Output |
|-------|-----|-------|--------|
| 1 Ingest | `ingest/` | 手机/表侧音频或导出 | `inbox/YYYY-MM-DD/` 元数据 |
| 2 Transcribe | `transcribe/` | inbox 指针或得到笔记 | `out/*.txt` 转写 |
| 3 Corpus | `corpus/` | 转写文本 | 规范化 Markdown → 仓库 `corpus/` |
| 4 Agent | `agent/` | 语料 Markdown | 决策卡 / PPT 大纲 |

运行顺序示例（本机）：

```bash
# 1) 放入音频后登记元数据
python pipeline/ingest/register_take.py --title "周会" --device iphone

# 2) 手工从得到粘好转写，或有 Key 后改 stub
#    → pipeline/transcribe/out/....txt

# 3) 规范化
python pipeline/corpus/normalize_stub.py \
  --transcript pipeline/transcribe/out/2026-11-03_sample.txt \
  --slug sample-meeting

# 4) 生成决策卡草稿（规则 stub；真智能力走 Grok Bot）
python pipeline/agent/render_decision_card_stub.py \
  --corpus corpus/examples/2026-11-03_sample-meeting.md
```
