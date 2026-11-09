# DayTap 组员接入文档（Onboarding）

> 给黑客松 / 协作组员｜2026-11-09｜**先读本文件，再动手装机。**  
> 电脑空间紧：**不必先整仓 clone**——在网页打开本页即可对齐口径；真机侧载时再按需浅克隆 `apps/DayTap` 所在的这一支。

---

## 0. 30 秒：我们在做什么

**DayTap**＝自研 **Apple Watch 开麦小工具**：腕上点一下说话 → 音频回手机 → 变成可整理语料。  
不是系统 Voice Memos，也不是「在得到里录」。

**黑客松形态（清华 Vibe Building 11/13–15）**  
- Watch App 为主  
- 手机端可先用 **网页看板**看结果（路演叙事）  
- 装上手表仍必须 **Mac + Xcode 侧载**（没有 TestFlight / App Store 包）

**30 秒路演口径**  
「腕上最短路径的想法捕获：手表录 → 手机接住 → 按场景进语料 / 得到 / 桌面知识库，避免又变成 Voice Memos 坟场。本场看侧载可用版；翻腕自动开录等是后续选项，不是当前主卖点。」

---

## 1. 仓库与分支（先搞清读哪）

| 项 | 值 |
|----|-----|
| 组员克隆（GitHub） | https://github.com/flicy/DayTap |
| Clone URL | `https://github.com/flicy/DayTap.git` |
| Origin 备用仓 | https://cursor.com/codebase/chris-cui/DayTap （PRIVATE） |
| Origin Clone URL | `https://origin.cursor.com/chris-cui/DayTap.git` |
| Watch MVP 工程 | PR [#1](https://cursor.com/codebase/chris-cui/DayTap/pull/1) · 分支 `cursor/daytap-watch-app-60a0`（GitHub `main` 与这一支是同一版） |
| 工程路径 | `apps/DayTap/DayTap.xcodeproj` |
| 本接入文档 | `docs/onboarding-teammates.md`（以仓内路径为准） |
| 只装手表 | [`docs/teammate-watch-sideload.md`](teammate-watch-sideload.md) |

**空间不够时（装机只做浅克隆）**  
1. 浏览器打开本文件对齐产品与装机步骤。读文档不要先 clone。  
2. 真要签装：不要 `git clone` 全历史。浅克隆、只要 Watch 这一支：  
   `git clone --depth 1 --branch cursor/daytap-watch-app-60a0 https://github.com/flicy/DayTap.git`  
   Origin 备用（同一分支）：  
   `git clone --depth 1 --branch cursor/daytap-watch-app-60a0 https://origin.cursor.com/chris-cui/DayTap.git`  
3. 不要装无关依赖；Xcode 只开 `apps/DayTap/DayTap.xcodeproj`（没有单独的 `.xcworkspace`）。

---

## 2. 能力与边界（别夸大）

### 现在能讲
1. **腕上短录**：Watch 一键开麦（会后倒、通勤闪念）  
2. **回手机分流（双轨）**  
   - 轨1：不进得到，进语料 / 飞书妙记 / Files  
   - 轨2：到手机后再进得到工作流  
   - 轨 B：Watch → iCloud → Mac 转写 → Obsidian/飞书（通用方案）  
3. **往后接助手**：语料 → 决策卡 / PPT（Grok Bot / skill）；对外主打「短捕获→可检索笔记」，AI 是加成  
4. **品牌**：眯眼软星精灵，薄荷绿 `#1DBA8A`；灵动捕获，不是严肃仪表

### 工程现状（务必说清）
- **没有**可点安装的 `.ipa` / TestFlight / App Store  
- Linux 云端 **编不了**真机包；以 **Mac 签装**为准  
- 当前 MVP 仍有很薄的 **iPhone Companion**（WatchConnectivity）；「手机网页」是黑客松看板方向，**替代不了第一次侧载**

### 不要当主卖点
- **翻腕 Raise to Speak**：玩笑级后续选项，非杀手级卖点

---

## 3. 手表怎么装（Mac + Xcode 侧载）

只想看装机、不看产品背景：[`teammate-watch-sideload.md`](teammate-watch-sideload.md)。  
签名、传输和限制的更细说明：[`daytap-watch-app.md`](daytap-watch-app.md)。

### 准备
- Mac + **Xcode 15+**  
- Apple ID（免费可侧载，约 **7 天**过期，再 Run 续签）  
- 已配对的 iPhone + Apple Watch；线连 Mac；手表解锁靠近

### 步骤
1. 浅克隆分支 `cursor/daytap-watch-app-60a0`（命令见 §1，不要拉全历史）  
2. 打开 `apps/DayTap/DayTap.xcodeproj`  
3. Target **DayTap** 与 **DayTap Watch App**：Automatically manage signing → Team 选你的 Apple ID  
4. Bundle id 默认 `com.chriscui.daytap`；冲突则改唯一 id，Watch 必须为 `<iphone-id>.watchkitapp`，并同步 `apps/DayTap/DayTapWatch/Info.plist` 的 `WKCompanionAppBundleIdentifier`（改成 iPhone 的 id，不要带 `.watchkitapp`）  
5. Scheme **DayTap** → 目标 **真机 iPhone** → Run  
6. 未信任开发者：设置 → 通用 → VPN 与设备管理 → 信任 → 再 Run  
7. 手表无图标：Scheme **DayTap Watch App** → 目标 Watch → Run，再对 iPhone Run 一次  
8. 冒烟：手表开始/停止录音 → iPhone 列表出现；空列表则靠近、双端打开、手表「再传一次」

模拟器测不了传文件。飞书备份：[组员装机指南](https://my.feishu.cn/docx/KFrWd5boro20TWx6MUpctJgenXf)

---

## 4. 协作怎么进仓

### GitHub（组员克隆用这个）
- 仓：https://github.com/flicy/DayTap  
- 浅克隆分支 `cursor/daytap-watch-app-60a0`（与 `main` 是同一版 Watch MVP）  
- 协作者示例：`guanlili` → https://github.com/guanlili  
- Chris 在该仓 Settings → Collaborators 邀请，对方 Accept

### Origin（备用）
- 仓主在 Cursor Origin 把组员 **Cursor 账号**加进 `chris-cui/DayTap`  
- 仅有 GitHub 用户名不够进 Origin；需要 Cursor 登录邮箱  
- 备用克隆：`https://origin.cursor.com/chris-cui/DayTap.git`

### 开发约定
- 从 `cursor/daytap-watch-app-60a0`（或合并后的 `main`）拉功能分支  
- **每人自己的 Mac + Apple ID** 签装到自己的设备  
- PR 写清：改了什么、是否真机测过录音与回传  
- 黑客松优先：**录稳 + 上传/列表通 + 网页能看**；得到 / 轨 B 一句带过即可

---

## 5. 黑客松时间盒（手册摘要）

| 日 | 事 |
|----|-----|
| 11/13 | 签到及开幕式 · 清华自强科技楼 5414 及中庭 |
| 11/14 | 集中开发：Watch 真机稳录 + 上传通 + 网页列表/播放 |
| 11/15 | 成果展示 / 路演 |

赛事手册（需登录）：https://kc8ig8gvnh.feishu.cn/wiki/BfluwhA60iDaU1kdIKVcq9InnOb  
组队表：https://kc8ig8gvnh.feishu.cn/base/SuYpbutZQaNd3KsL8FscFP5Jntc  
校外入校：https://kc8ig8gvnh.feishu.cn/share/base/form/shrcnUMVmUej102dDR1P2JQJ1Ec

---

## 6. 相关材料索引（仓内 / 外部）

| 材料 | 位置 |
|------|------|
| 组员装机短步骤 | [`docs/teammate-watch-sideload.md`](teammate-watch-sideload.md) |
| 产品架构 / 双轨说明 | `docs/`（如 [`daytap-watch-app.md`](daytap-watch-app.md)、[`watch-two-tracks.md`](watch-two-tracks.md)） |
| 零痛用法 | [`docs/tomorrow-zero-pain.md`](tomorrow-zero-pain.md) |
| PR #1 装机原文 | PR 描述「How to open and install on a Mac」 |
| 介绍小卡 / 海外 GTM 等 | 运营侧已归档；产品决策以本接入文档 + PR #1 为准 |
| 品牌 Figma | https://www.figma.com/design/My46193WfgQKdoDG1QncHo |
| 云端写 MVP 的 agent | https://cursor.com/agents/bc-d8992303-0fe9-5a5d-85ba-2a33964860a0 |

---

## 7. 组员检查清单

- [ ] 读完本文 §0–§2，能用自己的话讲清「是什么 / 不是什么」  
- [ ] 有仓权限（Origin 或 GitHub）  
- [ ] （可选）Mac 空间够时浅克隆 + Xcode 侧载通录音  
- [ ] 卡点时贴：**卡在第几步 + Xcode 报错原文**

有问题先队内同步，再找 Chris / DayTap Bot。
