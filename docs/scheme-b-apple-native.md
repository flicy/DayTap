# DayTap｜方案 B：苹果原生通用路径（无需得到）

> **口径更新**：腕上开录用 **DayTap Watch App**，不再用手表上的「语音备忘录」。音频先到 iPhone 的 DayTap，再把 m4a 送到 Mac 或飞书出字。下面关于 Mac 系统转写、Obsidian、飞书的能力说明仍然有效，只是文件来源变了。  
> **结论先行**：没有得到账号也能跑通「录音 → 文字 → 知识库 → Grok Bot」。  
> 主链是 **DayTap Watch App → iPhone 上的 m4a → 飞书妙记，或把文件送到 Mac 做系统转写 → Obsidian 和/或飞书知识库 → 同一套 Agent 层出决策卡 / PPT**。  
> 这是 Track 1。周五若要演示得到，走 Track 2（只在 iPhone 上分享/导入），不要从这条无得到链路拐进去。关键节点诚实标 **待验证**。

---

## 1. 为什么需要方案 B

- 不是每个人都有 **得到**（订阅、配额、工作流习惯都不同）。
- 对外开源 / Reddit / 小红书时，绑死单一中文产品会劝退海外与非得到用户。
- Chris 原话方向：手表录音 → iCloud 自动到 Mac → Mac 侧识别文字 → 沉到 Obsidian / 飞书 → 再交给 Personal Agent。

与方案 A **共用下游**：语料形态（Markdown）+ Grok Bot skills（决策卡 / PPT）。只换「录音与 ASR」段。

---

## 2. 数据流（最短闭环）

```text
DayTap Watch App 按需开录 → 停止
    → WCSession 把 m4a 传到 iPhone DayTap
    → Track 1 出字（不要送进得到）
         · 分享到飞书妙记，或
         · 「存到文件」/ 隔空投送到 Mac，用 Mac 语音备忘录或本机 Speech 转写
    → 粘贴或脚本写入 Obsidian vault 和/或 飞书知识库文档
    → （可选）同步一份进本仓库 corpus/ 规范格式
    → Grok Bot 读语料 → 决策卡 / PPT 大纲
```

**产品定位**：腕上入口是 DayTap，前台按需，不是全天。长会仍可用 Track 0 的 iPhone。方案 B 只是把 ASR 从「得到」换成「飞书或苹果侧出字」。iCloud 语音备忘录不再是手表文件的同步桥；若要借用 Mac 语音备忘录的转写，是把 DayTap 的 m4a **再导入**进去。

---

## 3. 2026 苹果栈：已公开能力 vs 待验证

调研基准：Apple Support 语音备忘录 / 备忘录文档 + 公开第三方实践（如本地 Speech 转写工具）。**未在本仓库作者设备上逐条复现的，一律「待验证」。不发明未公开 API。**

| 能力 | 公开事实（可引用 Support） | 本方案用法 | 状态 |
|------|---------------------------|------------|------|
| Watch → 其他设备同步 | Watch「语音备忘录」录音会同步到已登录同一 Apple Account 且开启 iCloud 语音备忘录的 iPhone / iPad / Mac | Watch 录 → Mac 可见 | **系统能力**（设备侧仍建议你亲手开一遍 iCloud） |
| Mac 语音备忘录转写 | Mac Voice Memos 可对录音做语音识别转写；可边录边看、录后查看/复制；可搜索标题与转写；**并非所有国家/地区可用** | 主 ASR 路径：在 Mac 打开录音 → 复制转写 | **可用（区域/语言待验证）** |
| 旧录音补转写 | 打开在较旧系统或「不支持转写的设备」上录的文件时，若含语音，Voice Memos 可自动转写 | Watch 旧片段到 Mac 后打开 | **待验证**（Watch 录音到 Mac 后是否总是自动出转写） |
| 备忘录 Notes 录音转写 | Notes 可在笔记内录音并出 live transcript；Mac 需 **M1 或更新**；语言白名单含简中/繁中/英/日等（以 Feature Availability 为准） | 备选：直接在 Notes 录并沉笔记 | **可用（硬件/语言待验证）**；**Watch 录音不会自动变成 Notes 音频附件** |
| Live Speech | 系统「实时语音」类辅助功能，面向听力辅助场景，不是「批处理整段备忘录文件」的通用导出 API | **不作为本方案主链** | 勿误用成 ASR 产品能力 |
| Speech framework（开发者） | 开发者可用 Speech（含较新的 on-device `SpeechAnalyzer` / `SpeechTranscriber` 等，版本与系统绑定）对本地音频转写；需 Speech Recognition 权限与语言模型下载 | 自动化批处理备选（监视 Voice Memos 录音目录 → 出 Markdown） | **待验证**（本机 macOS 版本、中文模型、权限、录音目录路径） |
| Continuity「自动共享就能识字」 | Continuity / Handoff 不等于「任意跨设备音频自动出全文」；Chris 记得的「电脑端自动共享识别很好」更接近 **iCloud 同步 + Voice Memos/Notes 系统转写**，而非单独 Continuity API | 对外话术用「iCloud + 系统转写」，避免喊 Continuity | **待验证表述**；文档口径以 Support 为准 |
| 无公开「导出全部转写」API | Voice Memos **无**官方 Scripting / 公开 Export-All-Transcripts API；第三方靠读录音文件 + Speech 或手动复制 | MVP 可手动复制；自动化另开 issue | **待验证自动化** |

**诚实边界**

- 不声称「Watch 全天后台录音是系统默认能力」（与 Auday / 本仓库既有约束一致）。
- 不声称苹果提供「服务器级、全语言、无区域限制」的云转写 API 给第三方随便调。
- 系统转写质量、说话人分离、会议场景准确率 → **待验证**，周五不承诺超过「可演示单段清晰人声」。

---

## 4. 文字沉淀：Obsidian / 飞书

| 落点 | 做法（MVP） | 后续 |
|------|-------------|------|
| **Obsidian** | 约定 vault 目录如 `Inbox/Voice/`；Mac 复制转写 → 新建 `YYYY-MM-DD_title.md`；可选 frontmatter：`source: watch-voicememo` / `scheme: B` | Folder 监控或 Shortcuts 半自动；与本仓 `corpus/` 二选一为真相源或双写 |
| **飞书知识库** | 新建文档或导入 Markdown；权限按「仅自己 / 小团队」 | 飞书 API / MCP 自动建页（另开 todo，非周五阻塞） |
| **本仓库 corpus/** | 对外 demo / Git 示例仍用 `corpus/examples/` 规范格式 | Agent 层输入统一成 Markdown，避免 Obsidian 与飞书分叉两套 prompt |

**Agent 层不变**：Grok Bot + skills 读 Markdown → 决策卡 / PPT（与方案 A 相同 stub：`pipeline/agent/`）。

---

## 5. 方案 A vs 方案 B

| 维度 | **方案 A**（手机主力 + 得到） | **方案 B**（Watch/备忘录 + iCloud + Mac ASR + Obsidian/飞书） |
|------|------------------------------|--------------------------------------------------------------|
| **适合谁** | 已有得到习惯、要中文会议笔记/整理、周五要最快出片 | 无得到、苹果全家桶、偏隐私/本地、要给海外或开源读者复现 |
| **录音主力** | iPhone Track 0，或 DayTap 手表文件再导入得到 | DayTap Watch App → iPhone 上的 m4a → 飞书或 Mac 出字 |
| **依赖** | 得到账号与转写配额；可选得到 OpenAPI | 同一 Apple Account；iCloud 语音备忘录；Mac（Notes 路径还要 M1+）；Obsidian 和/或飞书 |
| **ASR** | 得到转写 | Mac Voice Memos / Notes 系统转写；可选本机 Speech |
| **隐私** | 音频进得到云（按得到隐私政策） | 同步走 iCloud；转写偏设备侧系统能力；Obsidian 可全本地；飞书则进飞书云 |
| **自动化程度** | App 内录较顺；API 拉取 **待验证** | iCloud 同步顺；转写复制多为手动；目录监视+Speech **待验证** |
| **周五 demo 可行性** | **高（默认主演示）**：路径已写进 `tech-path.md` / demo script | **中**：现场可演示「Watch/备忘录 → Mac 出字 → 贴进 vault → Bot 出卡」；全自动链路不承诺 |
| **开源叙事** | 强依赖中文产品，海外需解释 | **更通用**；与 Auday「自配 API」叙事可对话，但我们钉的是 Agent 决策层而非全天录音硬件 |

**周五建议**：主 demo 走 A；开场或 Q&A 用 60 秒讲 B 的「无得到也能玩」，并指向本文。

---

## 6. 本周可做 / 不做

**可做**

- [ ] 在你的 Mac 上：开 iCloud 语音备忘录 → Watch 录 30 秒 → 确认 Mac 出现 → 打开转写并复制（记系统版本 / 是否出字）→ 把结果标成「已验证」回填本节表格
- [ ] 同一段文字分别丢进 Obsidian 与飞书，再让 Grok Bot 出一张决策卡（证明下游同一）
- [ ] README / 分享提纲加一句「双方案」

**不做（本周）**

- 不开发正式 macOS App
- 不承诺 Speech 批处理脚本周五必亮
- 不生成宣传片（见 `docs/todos/promo-video.md`）

---

## 7. 相关文档

- 方案 A 技术路径：[`tech-path.md`](tech-path.md)
- 架构总览：[`architecture.md`](architecture.md)
- vs Auday：[`vs-auday.md`](vs-auday.md)
- 产品介绍 TODO：[`todos/product-intro.md`](todos/product-intro.md)
