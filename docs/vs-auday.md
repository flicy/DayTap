# DayTap vs Auday（Puppet/BaiFu）：对齐还是差异化？

结论：**DayTap** 不跟 Auday 抢「全天 Watch 录音硬件」。我们有一个前台的 **DayTap Watch App**（同样用 WatchConnectivity 把文件送回 iPhone），但只按需录，不到后台假装全天。音频到 iPhone 后 Track 1 可以不进得到，Track 2 才在手机上交给得到，然后由 Grok Bot 出决策卡 / PPT。

## Auday 是什么（已核实公开信息）
- 产品：把 Apple Watch 做成全天候 AI 录音硬件（Auday）
- 架构：Watch 录音 → WatchConnectivity 回 iPhone；本地 ASR + 语义搜索；无后端；AI 用用户自配 API Key
- 卖点：续航优化、原音保留、心率/压力/位置作上下文、买断制（约 $9.9–19.8）
- 传播：国庆期 X 官号爆、多国付费榜、作者称七天约卖三十万

## Chris 方案 vs Auday

| 维度 | Auday | DayTap（本周 MVP） |
|------|-------|------------------|
| 录音主力 | Watch 全天 | **DayTap Watch App 前台按需**；文件在 iPhone；长课用手机 Track 0 |
| 转录 | 本地 ASR（可选云） | **得到**转写（待验证导出路径） |
| AI 层 | 用户自配 API，总结/高光/Chat | **Grok Bot** 语音指挥 + skill → **决策表 / PPT** |
| 角色 | 单 App 记忆 | **多 bot 角色切换**（群友提议） |
| 目标用户叙事 | 人生上下文录音硬件 | Personal Agent「听完就能拍板」 |
| 本周交付 | 已上架产品 | **Demo + 开源骨架 + 分享/公众号** |

## 可借鉴（公开信息层面）
1. WatchConnectivity 直传、不依赖「先上自家服务器」的叙事，适合讲隐私。
2. 「已经戴着的硬件」比新买录音卡/豆更低摩擦——我们讲 backup 时仍可用。
3. 买断 / 少账号：开源项目可对标「无订阅中转」。
4. 手动 Mark 高光：决策表场景可做成「拍一下 → 这段进 P0」。

## 我们必须讲清的差异（周五口径）
1. **不是做第二个 Auday**：Watch 不是全天主力，避免续航/合规正面硬刚。
2. **价值在 Agent 闭环**：转录进语料库后，Grok Bot 出**可执行决策卡**，不是停在「能搜到说过什么」。
3. **得到**是本周转录真源：流程要诚实标「人工/半自动导出」直到自动化验证。
4. 推送已在 Watch 上发生（Chris 日常）：「指挥」是下一步，先演示 **语料→决策表**，再讲 Watch 口令。

## 待验证
- [ ] 得到：录音如何导入、导出文本格式、是否有批量/API
- [ ] iPhone 按需录音：系统语音备忘录 vs 捷径 vs 第三方
- [ ] Watch backup：系统录音上限、与手机汇合方式
- [ ] Grok Bot：语音入口在 Watch 上实际能力边界（推送已有；指挥待测）
- [ ] 实时：群友说的「实时 PPT」——MVP 先做「会后数分钟内」还是真流式

## 一句话对外
> Auday 证明了 Watch 能当好录音硬件；我们证明 Personal Agent 能把「今天说的话」变成「今晚能拍板的决策表」。
