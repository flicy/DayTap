# DayTap 怎么用（Chris 方案 · 最短上手）

结论：仓库里已经有 **DayTap Watch App + iPhone 配套** 的源码，还不是上架 App。装到你自己的手表之后，用法是：**手表 DayTap 按需录音 → iPhone 收下文件 → 转写进语料 → 丢给本 bot 出决策表**。表还没装上时，用手机 Track 0。

**设备硬约束**：Apple Watch **没有**得到大脑。腕上麦克风是 **DayTap Watch App**，不是语音备忘录，也不是第三方录音机。安装步骤见 [`daytap-watch-app.md`](daytap-watch-app.md)。双轨见 [`watch-two-tracks.md`](watch-two-tracks.md)；明天私教点击级见 [`tomorrow-zero-pain.md`](tomorrow-zero-pain.md)。

---

## 你的方案一口径

| 角色 | 做什么 |
|------|--------|
| **Watch** | **DayTap Watch App** 前台开麦；停录后把 m4a 传到 iPhone。**不跑得到** |
| **iPhone** | DayTap 收文件、列表、分享。Track 2 才把文件 **分享/导入得到**；也可 Track 0 手机主录 |
| **得到** | **仅 iPhone**：Track 2 / 方案 A 的 ASR |
| **Track 1（无得到）** | DayTap Watch→iPhone 文件→飞书妙记 / 快捷指令 / Mac 转写 / Obsidian 文字 → Bot |
| **语料库** | 按「日 / 场 / 人」落 Markdown（Bot 可代写；见 `corpus/`） |
| **Grok Bot** | 读语料 → **决策卡 / PPT 大纲** |

周五对外叙事钉：**Watch + Grok Bot**；不跟 Auday 抢全天 Watch 录音硬件。

---

## 今天/明天最小用法

1. **定开录端**  
   - 腕上：Mac 打开 `apps/DayTap/DayTap.xcodeproj`，签名后 Run 到配对 iPhone（手表会带上 DayTap）。课上点 **开始 / 停止**。  
   - 表还没装好，或这节课很长：**Track 0** 手机录。  
2. **定转写轨**  
   - **Track 1**：不进得到 → Mac / 飞书 / 系统文稿出字。  
   - **Track 2**：音频到 iPhone → 分享或导入 **得到大脑** → 出字。  
3. **沉淀**：把转写全文发给本 Bot（你**不必**先手写 `corpus/...md`）。  
4. **拍板**：说「出决策卡」；要分享再说「出页纲」。

样例：`corpus/examples/`。自动化脚本在 `pipeline/` 仍是占位。

---

## 和「完美形态」的差距（诚实）

| 能力 | 现状 |
|------|------|
| Watch 录 → 双轨出字 → 决策卡 | **文档已写清**；课上按点击跑通即验证 |
| 表上点结束自动进得到 | **不存在**（表无得到 App） |
| 得到 / Mac 转写一键进库 | 半自动，待验证 |
| Watch 语音指挥 Bot | 推送已有；指挥待验证 |
| 实时当场 PPT | 目标态；MVP = 会后数分钟内出表 |

---

## 建议课前试一次（5 分钟）

手表 DayTap 录 10 秒 → 确认 iPhone 的 DayTap 列表里有文件 → 分别试一次 Track 1 出字、Track 2 进得到。列表是空的就点手表「再传一次」。还是不通就改 Track 0，课上不硬刚。
