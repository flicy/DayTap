# Stage 2 — Transcribe（得到交接）

**职责**：把音频变成「转写正文」。默认引擎：**得到（得到大脑）**。

## 保底（手工）

1. 得到 App 内录，或导入 `ingest` 中的音频。  
2. 转写完成后，复制正文到：  
   `pipeline/transcribe/out/YYYY-MM-DD_<slug>.txt`  
3. 同名可附 `*.meta.json` 记录得到笔记 ID（可选）。

## 半自动（有 OpenAPI Key）

- 官方入口：https://www.biji.com/openapi  
- Base：`https://openapi.biji.com/open`  
- 鉴权：`Authorization: gk_live_…`、`X-Client-ID: cli_…`（**无 Bearer 前缀**，以官方文档为准）  
- `fetch_dedao_stub.py`：演示如何读环境变量并发起 list 请求骨架；**不内置 Key，不声称已覆盖 transcript 全字段**。

### 待验证

- [ ] 录音笔记是否只能在 App/Web 创建（社区 MCP 文档如此说）  
- [ ] `get_note_transcript` 类接口的官方路径与字段  
- [ ] 导出 PDF/DOCX/MP3 与「纯转写文本」哪个最稳进语料库  

## 目录

- `out/` — 转写输出（可提交脱敏样例；真实稿自行决定）  
- `fetch_dedao_stub.py` — API 骨架
