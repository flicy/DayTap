# DayTap｜MVP 技术路径 Tech path

> 目标：周五前打通「一段录音 → 一篇语料 → 一张决策表」。  
> 凡未亲自在本机验证的，一律标 **「待验证」**。不含真实 API Key。

## 0. MVP 默认路径（本周）

```text
腕上：DayTap Watch App 前台开录 → 停止
    → WCSession.transferFile 把 m4a 传到 iPhone 上的 DayTap（手机不在身边会排队）
    → 同一文件分叉：
         Track 1  飞书妙记 / 快捷指令 / Mac 转写（不进得到）
         Track 2  iPhone 上分享或导入得到大脑
保底 Track 0：iPhone 自己录（得到内录，或语音备忘录 / 飞书妙记）
    → 转写文本 → pipeline/transcribe/out/ → corpus/
    → Grok Bot 读 Markdown → 决策卡 / PPT 大纲
```

手表工程：`apps/DayTap/DayTap.xcodeproj`。安装与限制见 `docs/daytap-watch-app.md`。  
DayTap 还没装上手表时，Track 0 不阻塞「一段录音 → 一篇语料 → 一张决策表」。

---

## 1. iPhone 录音选项

| 方案 | 优点 | 缺点 / 风险 | MVP 建议 |
|------|------|-------------|----------|
| **系统「语音备忘录」** | 零开发；iCloud 可在 iPhone/iPad/Mac 间同步（系统能力） | 转写需另走得到；自动化弱 | **首选主轨** |
| **得到 App 内直接录音** | 录完即转写，少一跳 | 绑定得到账号与配额；导出习惯要定 | **并列首选**（若你已在用） |
| **Shortcuts 调录音** | 可做「一键开录」；Watch 可跑部分快捷指令 | 能力随系统版本变；长录音体验一般 | 快捷触发用 |
| **DayTap iPhone 配套** | 收手表 m4a，分享表可交给得到或飞书 | 要先在 Mac 上签名安装；未上架 | **Track 1/2 的手机收件箱** |
| **第三方录音 App** | 可能有自己的手表端 | 不是 DayTap 的腕上路径 | 不用 |

**待验证**：Track 2 是「DayTap 分享 → 得到」还是得到里「导入音视频」更稳。周五如果两条都要演示，课前各走通一次；走不通的那条当场改口，不假装已经自动。

---

## 2. Apple Watch：backup / sync 约束（诚实版）

下列综合 Apple 文档与业界实践；**未在本仓库作者设备上逐条复现的标「待验证」**。

### 已知偏硬的约束

1. **手腕放下后 App 易被挂起**：普通 Watch App 不能假设无限后台跑。
2. **Extended Runtime Session** 有类型与时长上限（如 self-care 约 10 分钟、mindfulness / physical therapy / smart alarm 等各有窗口）；且须按真实用途申请，**不能为了录音滥用类型**（Apple 审核与政策风险）。
3. **后台无法随意「新开」录音**：常见错误是后台发起 AVAudio 输入被拒；通常需前台已开始，或中断后回到前台再续。
4. **来电 / Siri / 闹钟等会打断录音**：前台或可自动续，后台往往要用户点一下再开（第三方实践常见）。
5. **麦克风物理限制**：麦在表冠侧；衣袖遮挡、风噪、距离说话人过远都会差；房间级多人会议更应用 iPhone。
6. **电量**：长录会明显耗电；低电可能直接停录（第三方文档常见描述）。

### 同步现实

| 路径 | 说明 | 状态 |
|------|------|------|
| DayTap `WCSession.transferFile` | 手表本地 m4a 排队传到配对 iPhone 的 DayTap。这是选定的桥，不是语音备忘录 iCloud | 代码已写；真机送达 **待验证** |
| 语音备忘录 + iCloud | 系统录音在苹果设备间同步 | 只作为 Track 0 / Mac 出字的可选手段，**不是**腕上麦 |
| Continuity / 自动接力开录 | 不要默认「表上一键 = 手机无感长录」 | **待验证** / 多半需 Shortcuts 设计 |
| Grok Bot → Watch 推送 | 你已在用「天天推送」——作为指挥与提醒入口 | 产品已验证（用户侧）；自动化深度 **待验证** |

**产品结论**：腕上麦克风 = **DayTap Watch App**（前台、按需）。音频文件的家在 iPhone。Track 1 与 Track 2 都从这份 iPhone 上的 m4a 分叉。手表不连接得到。全天后台录音仍然不做。

---

## 3. 得到转写交接

### 已公开可查（非密钥）

- 产品侧：得到大脑支持录音 / 会议 / 课堂转写；支持导入音视频生成转写与总结（官方文档有「导入音视频」「录音笔记导出 MP3」等更新说明）。
- **开放平台**：`https://www.biji.com/openapi`  
  - Base：`https://openapi.biji.com/open`（列表示例路径含 `/api/v1/resource/note/list`）  
  - 鉴权头：`Authorization: gk_live_xxx`（文档写明无 Bearer 前缀）、`X-Client-ID: cli_xxx`  
  - 用途：程序化管理笔记。
- 社区 MCP（如 getnote-mcp）文档提到 `get_note_transcript` 等工具可读录音/会议转写；并提示 **录音笔记无法通过 API 创建，只能在 App/Web 创建**（社区说法 → 仍标 **待验证** 以官方 OpenAPI 全文为准）。

### MVP 手工路径（本周保底）

1. 在得到 App 完成录音或导入音频，等转写完成。  
2. 复制转写正文，或导出得到支持的格式，贴到：  
   `pipeline/transcribe/out/YYYY-MM-DD_<slug>.txt`  
3. 跑 `pipeline/corpus/normalize_stub.py` 生成语料 Markdown。

### 半自动路径（有 Key 后）

1. 本机 `.env`：`DEDAO_CLIENT_ID` / `DEDAO_API_KEY`（**勿提交**）。  
2. 用 `pipeline/transcribe/fetch_dedao_stub.py` 的流程去调官方 list / transcript 类接口。  
3. **待验证**：转写字段名、分页、音频笔记 `note_type`、是否包含完整逐字稿 vs 仅 AI 摘要。

### 明确不做的假设

- ❌ 不假装「得到有无密钥公共 ASR API 谁都能打」。  
- ❌ 不在仓库里放任何 `gk_live_` / `cli_` 样例真值。

---

## 4. Grok Bot 集成点

| 能力 | Bot / Skill 能做什么 | 通常还需要 |
|------|----------------------|------------|
| 读本地/云文档语料 | 已接入的文件、Drive、或用户粘贴 | 语料先落到 Markdown |
| 语音指挥 | 若 Bot 侧有语音入口 / 手表推送后的文字指令 | Watch 上完整语音链路 **待验证** |
| 出决策卡 / PPT 大纲 | Prompt + `pipeline/agent/` 模板 | 人工确认后再外发 |
| 调电脑 Skill | 本机已装 skill 时可由 Bot 跑脚本 | 权限、路径、是否登录 |
| 多角色切 Bot | 多个 Bot 或多套 system prompt | 一键切换 UX **待验证** |
| Shortcuts 自动化 | 录音结束 → 文件落到 inbox → 通知 Bot | iOS 快捷指令权限与稳定性 **待验证** |

**MVP 演示集成（最低摩擦）**：

1. 打开 `corpus/examples/2026-11-03_sample-meeting.md`  
2. 对 Grok Bot：「按 `pipeline/agent/templates/decision-card.md` 生成决策卡」  
3. 对照 `corpus/examples/2026-11-03_sample-decision-card.md`  
4. （可选）再要一版 PPT 大纲

自动化「录音结束自动喂 Bot」放到周五后迭代。

---

## 5. 本周不做 / 延后

- 把 DayTap 提交 App Store 或对外说已经上架（源码只供自己的手表签名安装）
- 端到端流式 ASR + 实时幻灯片翻页  
- 声称已卖货 / 已有付费闭环（那是对标故事，不是本仓现状）  
- 未验证就写死「得到 API 可上传录音」

---

## 6. 验证清单（打勾再用）

- [ ] Mac 打开 `apps/DayTap/DayTap.xcodeproj`，签名后装到配对手表和 iPhone  
- [ ] 手表 DayTap 录 10 秒 → iPhone DayTap 列表出现 m4a  
- [ ] 同一文件分别走通 Track 1（不进得到）和 Track 2（iPhone 分享/导入得到）  
- [ ] 一段 ≥3 分钟真实独白 → 得到转写可用（Track 2 或 Track 0）  
- [ ] 转写进入 `corpus/` 格式稳定  
- [ ] Grok Bot 用模板稳定产出决策卡  
- [ ] 能讲清：表上只录、得到只在手机、前台录音不是全天  
- [ ] （可选）得到 OpenAPI list + transcript 拉通  

验证日期与设备请记在 issue 或 `docs/` 短日志里，方便周五口述「我们测过什么」。
