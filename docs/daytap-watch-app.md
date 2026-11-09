# DayTap Watch App

> 腕上麦克风就是这个 App。不是系统「语音备忘录」，不是第三方录音机。  
> 手表只录音，不连接得到。音频用 WatchConnectivity 传到配对 iPhone 之后，Track 1 和 Track 2 都还在。  
> **这不是 App Store 版本。** 明早要上课，得在 Mac 上签名装到自己的手表。

最低系统：iPhone iOS 17，Apple Watch watchOS 10。用 Xcode 15 或更新的正式版打开。更新的 Xcode 若提示「部署目标太旧」，把两个 target 的最低系统调到它允许的最低值即可，不要降到 iOS 17 / watchOS 10 以下。

---

## 明早在 MacBook Air 上装到手表

工程在仓库里的这个文件（双击它，不要另找 workspace）：

`apps/DayTap/DayTap.xcodeproj`

1. 安装并打开 **Xcode**（Mac App Store 的正式版，不要只用命令行）。
2. 双击 `apps/DayTap/DayTap.xcodeproj`。左边应看到两个 target：**DayTap**（iPhone）和 **DayTap Watch App**（手表）。
3. 点最上面的蓝色工程图标 **DayTap**。
4. TARGETS 选 **DayTap** → **Signing & Capabilities** → 勾上 **Automatically manage signing** → **Team** 选你的 Apple ID。  
   Bundle Identifier 先保持 `com.chriscui.daytap`。若提示被占用，改成你自己的一段，例如 `com.你的名字.daytap`，并且马上做第 5 步的配套修改。
5. TARGETS 选 **DayTap Watch App** → 同一个 Team，同样勾自动签名。  
   Bundle Identifier 必须是 iPhone 那个 ID 再加 `.watchkitapp`。  
   若你改了 iPhone 的 ID，还要打开 `apps/DayTap/DayTapWatch/Info.plist`，把 `WKCompanionAppBundleIdentifier` 改成 **iPhone 的** Bundle ID（不带 `.watchkitapp`）。
6. 数据线插上 iPhone，解锁，点「信任」。手表戴在腕上，跟这台 iPhone 配对，手表也解锁。
7. Xcode 顶部 scheme 选 **DayTap**（不是 Watch 那个）。目的地选 **你的 iPhone**。不要选模拟器。按 **Run**（播放键）。
8. iPhone 若打不开：设置 → 通用 → VPN 与设备管理 → 信任你的开发者证书。然后再 Run 一次。
9. 手表主屏幕找 **DayTap**。没有的话：scheme 改成 **DayTap Watch App**，目的地选你的 Apple Watch，再 Run 一次。然后 scheme 切回 **DayTap**，对 iPhone 再 Run 一次，保证手机端也在。
10. 手表打开 DayTap → 允许麦克风 → 点 **开始** → 说两句 → 点 **停止**。
11. iPhone 打开 DayTap，列表里出现这一条。点 **分享**。
    - **Track 2**：分享表里选 **得到大脑**。没有的话，打开得到 → 导入音视频 → 文件 → 我的 iPhone → DayTap。
    - **Track 1**：不要选得到。分享到飞书妙记，或点 **存到文件**，或隔空投送到 Mac 做系统转写。出字后把文字贴给 Bot。
12. 列表是空的：两台设备靠近、屏幕亮着，都打开 DayTap，手表点 **再传一次**。

免费 Apple ID 签名大约 7 天后失效，过期就再 Run 一次。付费开发者账号才能上 TestFlight。今晚没有提交 App Store，也不能在商店里搜到 DayTap。

模拟器可以打开界面，但 **传文件必须用真手表 + 真 iPhone**。Apple 的 `transferFile` 在模拟器上不可靠。

---

## 架构

```text
Apple Watch  DayTap（前台点开始 / 停止）
    AVAudioRecorder → 单声道 AAC .m4a，留在手表本地
    WCSession.transferFile  （系统排队；手机不在身边也会排队）
        ↓
iPhone  DayTap
    didReceive 里立刻把文件拷进「文稿」目录，再回执
    列表 + 分享表 + 「存到文件」
        ↓
    Track 1  飞书妙记 / 快捷指令 / Mac 系统转写 → 文字 → Bot
             （不进得到）
    Track 2  分享或导入 → 得到大脑（只在这台 iPhone）
```

两边的 Bundle ID：

| Target | Bundle ID | 屏幕上的名字 |
|--------|-----------|----------------|
| DayTap | `com.chriscui.daytap` | DayTap |
| DayTap Watch App | `com.chriscui.daytap.watchkitapp` | DayTap |

源码目录：

| 路径 | 作用 |
|------|------|
| `apps/DayTap/DayTapWatch/` | 手表：一个开始/停止按钮、录音、传输、失败重试 |
| `apps/DayTap/DayTap/` | iPhone：收文件、列表、分享、存到文件、`daytap://recordings` |
| `apps/DayTap/Shared/` | 两边共用的索引和文件名规则 |

iPhone 的录音文件在 App 的文稿目录。因为打开了「文件共享」，可以在 **文件 → 我的 iPhone → DayTap** 里看到 m4a。索引 `index.json` 放在 Application Support，不会出现在文件 App 里。

---

## 为什么用 WatchConnectivity 传文件

核对过 Apple 现在仍公开的配套 App 做法（WWDC21《There and back again: Data transfer on Apple Watch》，以及 `WCSession.transferFile` 文档）：

- 传完成的音频文件，用 `WCSession.transferFile(_:metadata:)`。系统把文件放进队列，电量和连接允许时再送。调用时手机不可达也要入队，这就是「不在身边会重试」的系统部分。
- iPhone 在 `session(_:didReceive:)` 返回之前必须把文件拷走。返回后系统会删掉收件箱里的临时文件。
- `outstandingFileTransfers` 用来识别「已经在系统队列里」，避免同一次再交一份。
- `session(_:didFinish:error:)` 失败时，手表把这条标成失败，过几秒以及下次回到前台再交。
- 手机真正写入文稿目录之后，用 `transferUserInfo` 回一条确认。手表收到才标成「iPhone 已保存」。手机写失败就不回执，手表保留原文件。
- 同一个录音 id 再传一次时，手机若已有该文件就不再覆盖，只补回执。
- `sendMessage` 只适合小字典，而且要求当时连得上，不用它传音频。
- 不走 iCloud 语音备忘录。Chris 的手表上没有语音备忘录，产品也不再把系统备忘录当腕上麦克风。

这条链路写进了源码，**还没有在 Chris 的真机上跑过**。明早第一次 Run 就是验证。

---

## 隐私字符串和后台模式

| 位置 | 键 | 原因 |
|------|----|------|
| 手表 `DayTapWatch/Info.plist` | `NSMicrophoneUsageDescription` | 手表上真的会开麦 |
| iPhone `DayTap/Info.plist` | `NSMicrophoneUsageDescription` | 隐私清单里写明用途。这一版 iPhone App **不调用**麦克风，拒绝它也不影响收文件 |
| 两边 | 无 `UIBackgroundModes` / `WKBackgroundModes` | 不需要。传文件时系统会自己唤醒 iPhone App。手表录音只在前台 |

手表放下手腕、DayTap 进入后台时，会停止并保存，然后排队上传。不使用延长运行会话：现有会话类型对不上「上一节课」，不能为了续录去套一个不真实的类型。来电、Siri、闹钟打断时，同样停下来保存，不会在通话结束后自己接着录。

---

## 已知限制

- 手表上没有得到，也不会有。得到只出现在 iPhone 的分享或导入里（Track 2）。
- 不是全天候后台录音。长课、人坐着不动，仍用 Track 0：手机上的得到、语音备忘录或飞书妙记。
- 未上架，未交 App Store，没有隐私清单 `PrivacyInfo.xcprivacy`（那是上架材料）。
- 这台写代码的环境是 Linux，没有 Xcode，没有手表，**没有编译、没有装到设备上**。能打开、能签名、能装上，要等 Mac。
- 课前 10 秒试录若失败，不要在课上硬刚，改 Track 0。

相关操作页：[`tomorrow-zero-pain.md`](tomorrow-zero-pain.md)、[`watch-two-tracks.md`](watch-two-tracks.md)。
