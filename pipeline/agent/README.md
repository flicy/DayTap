# Stage 4 — Agent outputs

**职责**：基于语料生成 **决策卡** / **PPT 大纲**。  
真智力默认走 **Grok Bot + skills**；本目录提供模板与可离线跑的 stub（规则填充，便于 CI/无网 demo 兜底）。

## 模板

- `templates/decision-card.md` — 决策卡结构  
- `templates/ppt-outline.md` — 五页以内大纲  

## Stub

`render_decision_card_stub.py` — 从语料 front-matter 填标题，正文放「请交 Grok Bot」占位；或读取已有示例。

## 多角色

同一语料可切换不同 Bot / prompt（决策参谋、分享编剧、复盘教练）。自动化切 Bot：**待验证**。
