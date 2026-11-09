# DayTap｜架构说明 Architecture

> 产品名：**DayTap**。口径见仓库 README。本文展开角色、数据流与隐私。

## 1. 角色分工

| 组件 | 产品职责 | 不做 |
|------|----------|------|
| **iPhone** | 收下 DayTap 手表音频并分享；Track 0 时也可自己开录；承载转写前的文件 | 不强迫全天录；这一版配套 App 自己不开麦 |
| **Apple Watch** | **DayTap Watch App**：前台按需开录，停录后把文件传到 iPhone。也可收 Grok Bot 推送 | 不连接得到；不承诺全天无中断后台录音 |
| **得到（得到大脑）** | ASR 转写 + 笔记整理 | 不默认假设「无密钥公开随便调」；密钥不进仓库 |
| **语料库（本仓 `corpus/`）** | 最终沉淀：按日 / 场 / 人的 Markdown 文档 | 不把原始音频当长期唯一真相 |
| **Grok Bot + Skills** | 读语料 → 决策卡 / PPT 大纲；多 Bot 角色切换 | 不替代人工对关键决策的确认 |

群聊当时的说法是「手机主力 + Watch backup」。同日稍后的产品决定改成：腕上麦克风是 DayTap Watch App，音频落到 iPhone 后再分 Track 1 / Track 2；Track 0 手机录保留为保底。Anatole 期待 Watch 上指挥 Grok；云飞扬关心实时决策表/PPT；有人提出接语音 API + skill + 切 Bot。

## 2. 逻辑数据流

```text
[按需录音]
   │
   ├─ Track 0  iPhone 自己录 ──────────────────┐
   │                                            │
   └─ DayTap Watch App ── transferFile ─► iPhone DayTap
                                                ▼
                                     按天整理 → ingest/inbox
                                                │
                         ┌──────────────────────┴───────────────────────┐
                         ▼                                              ▼
              Track 1 不进得到（飞书 / Mac）                 Track 2 得到（仅 iPhone）
                         └──────────────────────┬───────────────────────┘
                                                ▼
              规范化 Markdown → corpus/
                         │
                         ▼
              Grok Bot（voice/API + skills）
                         │
              ┌──────────┴──────────┐
              ▼                     ▼
         决策卡 .md            PPT 大纲 .md
```

**实时性说明**：MVP 的「实时」指 **会后数分钟内** 出决策卡（人工或半自动把转写丢给 Bot），不是端到端毫秒级流式 ASR。流式路径标为后续增强（待验证）。

## 3. 目录与产物映射

| 阶段 | 路径 | 产物 |
|------|------|------|
| 采集 | `pipeline/ingest/` | 元数据 JSON + 音频指针（音频默认不入库） |
| 转写交接 | `pipeline/transcribe/` | 原始转写文本 / 得到笔记导出 |
| 语料规范化 | `pipeline/corpus/` | 标准 front-matter Markdown |
| Agent | `pipeline/agent/` | 决策卡、PPT 大纲模板与 stub |
| 示例终态 | `corpus/examples/` | 可展示的假数据 |
| 真实日更 | `corpus/daily/`（gitignore） | 隐私语料，仅本机 |

## 4. 隐私与合规 Privacy

1. **告知与同意**：对他人录音前需符合当地法律与场合规范；演示时优先用自有独白或已授权会议。
2. **最小化**：公开仓库只放 `corpus/examples/` 虚构样例；真实音频与转写默认 gitignore。
3. **密钥**：得到 OpenAPI Key / Client ID、Grok 相关凭证只放本机 `.env`，永不提交。
4. **云端**：得到转写即云端处理——敏感合同、账号、未公开商业谈判慎用；可改为本地 ASR（非本周 MVP）。
5. **Watch 推送**：Grok Bot 推送到手腕的是摘要/提醒级信息，避免把原文隐私刷到表盘。
6. **删除权**：语料库按「日/场」文件组织，便于整场删除；pipeline 应保留 source 指针便于追溯。

## 5. 多 Bot 角色切换

同一语料可喂给不同角色 Bot（示例，非绑定实现）：

| 角色 | 输出偏向 |
|------|----------|
| 决策参谋 | 决策卡：选项 / 利弊 / 建议下一步 |
| 分享编剧 | PPT 大纲：故事线、金句、一页一结论 |
| 复盘教练 | 行动项、未决问题、下次议程 |

切换方式（MVP）：不同 system prompt / 不同 Grok Bot 实例；自动化切 Bot 标为待验证。

## 6. 与对标产品的关系

群内分享过「七天把 Apple Watch 做成 AI 录音硬件」类实践。2026-11-03 的产品决定把腕上麦克风收成第一方 **DayTap Watch App**（前台、按需），同时仍然不押全天无中断后台录音。音频到了 iPhone 才分 Track 1 / Track 2。价值仍在：

- 手表文件能落到 iPhone（WatchConnectivity，真机待验证）
- Track 0 在表没装好时仍然能录
- 得到只在 iPhone 上转写；Track 1 可以完全不进得到
- Personal Agent 把语料变成 **可行动卡片**

不要把它讲成已经上架的全天录音硬件。
