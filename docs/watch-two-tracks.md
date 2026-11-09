# DayTap · Watch 双轨（无得到 / 有得到）

> **腕上麦克风是 DayTap Watch App。**  
> 不是系统「语音备忘录」，不是 Just Press Record / Wave / 别的第三方录音机。  
> Apple Watch **没有**得到大脑。手表只把音频传到配对 iPhone。得到只可能出现在 **iPhone 的分享或导入**。

怎么在 Mac 上装进手表：[`daytap-watch-app.md`](daytap-watch-app.md)。  
明早点击顺序：[`tomorrow-zero-pain.md`](tomorrow-zero-pain.md)。

真机传输还没在 Chris 的手表上复现，标 **待验证**。按钮名以表上和手机上实际界面为准。

---

## 三轨总览

| 轨 | 谁开录 | 是否进得到 | 什么时候用 |
|----|--------|------------|------------|
| **Track 0** | **iPhone** 上的得到、语音备忘录或飞书妙记 | 可选 | 表上还没装好 DayTap、或长课坐着不动。这是保底，不是否定腕上开录 |
| **Track 1** | **DayTap Watch App** | **不进得到** | 腕上按需录。音频到 iPhone 后走系统转写 / 飞书妙记 / Obsidian 文字 |
| **Track 2** | **DayTap Watch App** | **进得到**（仅 iPhone） | 同一段音频到 iPhone 后，分享或导入得到大脑 |

Track 1 和 Track 2 是 **同一段手表录音** 到了 iPhone 之后的两条去向，都要能走。不是二选一删掉另一条。

```text
Track 0:  iPhone 录 →（得到 或 飞书 / 系统转写）→ 文字 → Bot
Track 1:  DayTap Watch App 录 → 传到 iPhone → 飞书妙记 / 快捷指令 / Mac 转写 / Obsidian 文字 → Bot
          （这条音频不要送进得到）
Track 2:  DayTap Watch App 录 → 传到 iPhone → 分享或导入「得到大脑」→ 文字 → Bot
```

---

## 手表上用谁开麦

| 入口 | 事实 | DayTap 怎么用 |
|------|------|----------------|
| **DayTap Watch App** | 本仓库里的第一方手表 App。前台点开始/停止，AAC m4a 经 WatchConnectivity 传到 iPhone 上的 DayTap | **Track 1 和 Track 2 的腕上麦克风**。装上之后，明早和本周演示都用它 |
| **得到大脑** | 没有 watchOS App | 手表上做不到。只在 Track 2 的 iPhone 上吃文件 |
| **系统语音备忘录** | 系统可以装，Chris 的手表上没有，产品不再用它当腕上麦 | **不要**为了 DayTap 去装。iPhone 上的语音备忘录仍可作为 Track 0 |
| **第三方手表录音 App** | 各家自己的同步，之前标过待验证 | **不是**这条产品路径 |
| **体能训练 / 屏幕录制** | 不是会议人声文件 | 不用 |

没有把 DayTap 装到手表上 = 腕上两轨都走不通，改 Track 0。

---

## 音频怎么到 iPhone

用的是 Apple 配套 App 的文件传输：`WCSession.transferFile`。

- 点停止后，文件先留在手表，并交给系统队列。
- 当时 iPhone 不在身边、没开着 DayTap，也会排队；靠近后再送。手表上可以点 **再传一次**。
- iPhone 的 DayTap 把 m4a 放进自己的文稿目录，并在 **文件 → 我的 iPhone → DayTap** 里可见。
- 模拟器传不成。必须是配对的真手表和真 iPhone。
- 这条传输的代码在仓库里，**真机是否一次送到：待验证**。

细节和签名步骤见 [`daytap-watch-app.md`](daytap-watch-app.md)。

---

## Track 1 · 无得到

腕上停录之后 **不经过得到**，在苹果或飞书侧出字，再交给 Bot。

```text
手表 DayTap：开始 → 停止
  → iPhone DayTap 列表里出现这条 m4a
  → 出字（不要选得到）
       A. 分享 → 飞书妙记
       B. 「存到文件」或隔空投送 → Mac 上打开做系统转写
       C. iPhone 快捷指令「转录」（机型和语言有门槛 · 待验证）
  → 全文贴给 Bot：「私教 · Track1 · 出决策卡」
```

Obsidian 只收 **文字**。把裸 m4a 丢进库不会自动变成文稿。

点击：

1. 手表打开 **DayTap** → **开始** → 下课 **停止**。
2. iPhone 打开 **DayTap** → 点开最近一条 → **分享**。
3. 选飞书妙记，或存到文件 / 送到 Mac。不要选得到大脑。
4. 复制文字，发给 Bot。

诚实边界：停录不等于马上出字。全自动「结束 → Obsidian 里已有 md」本周不承诺。飞书要进 **妙记**，不是随便丢进聊天。

---

## Track 2 · 有得到（只在 iPhone）

手表只负责开麦。得到大脑只在 iPhone 上吃这个音频。

```text
手表 DayTap：开始 → 停止
  → iPhone DayTap 收到 m4a
  → 分享，或得到里「导入音视频」
  → 得到出字 → 复制 → Bot：「私教 · Track2 · 出决策卡」
```

点击：

1. 手表：**DayTap** → 开始 → 停止。和 Track 1 是同一下。
2. iPhone：**DayTap** → 该条 → **分享** → **得到大脑**。  
   分享表里没有得到时：打开得到大脑 → **+ → 导入音视频** → 文件 → 我的 iPhone → DayTap。
3. 等转写完，复制文字记录，发给 Bot。

诚实边界：

- 不存在「手表点停止就自动进得到」。
- 得到没有公开「监视某个文件夹自动吞 DayTap 录音」的文档。明早靠分享或导入这两下。
- 长课注意得到转写额度。

---

## Track 0 · 手机保底（仍有效）

DayTap 还没装上手表、试录 10 秒失败、或这节课很长而且人坐着：

- **有得到**：iPhone 得到大脑里直接开录。
- **无得到**：iPhone 语音备忘录或飞书妙记开录，出字后给 Bot。

和腕上双轨并存。Track 0 用的是手机上的录音入口，不是手表上的语音备忘录。

---

## 明早怎么选

```text
手表上有没有装好并能开麦的 DayTap？
  ├─ 没有，或 10 秒试录到不了 iPhone → Track 0（手机录）
  └─ 有 → 课上用 DayTap 录
           ├─ 课后要得到 → Track 2（iPhone 上分享/导入）
           └─ 不进得到 → Track 1（飞书 / Mac / 快捷指令）
```

---

## 和其他文档

| 文档 | 角色 |
|------|------|
| [`daytap-watch-app.md`](daytap-watch-app.md) | 工程、签名、安装、传输机制、限制 |
| [`tomorrow-zero-pain.md`](tomorrow-zero-pain.md) | 明早私教的点击页 |
| [`scheme-b-apple-native.md`](scheme-b-apple-native.md) | Track 1 出字之后的 Mac / Obsidian / 飞书。音频来源已改为 DayTap 的 m4a，不是手表语音备忘录 |
| [`tech-path.md`](tech-path.md) | Track 2 / 得到 API，以及手表前台录音的限制 |
| [`how-to-use-chris-scheme.md`](how-to-use-chris-scheme.md) | 日常最短上手 |

---

## 一句话

**表上只点 DayTap 的开始和停止；文件到 iPhone 之后，要么不进得到（Track 1），要么在手机上交给得到（Track 2）。两条都要能走。**
