# DayTap 组员指南：怎么把 Watch App 装上手表

> 给黑客松组员｜2026-11-09｜结论先行：现在没有 TestFlight / 安装包可点，只能用 Mac + Xcode **侧载**；每人用自己的 Apple ID 签到自己的 Watch。

产品是什么、协作规则、黑客松时间：先读 [`onboarding-teammates.md`](onboarding-teammates.md)。本文只讲怎么装上手表。

磁盘紧：**不要为了读文档先 clone**。真要装机时用浅克隆，不要拉全历史：

`git clone --depth 1 --branch cursor/daytap-watch-app-60a0 https://github.com/flicy/DayTap.git`

Origin 备用（同一分支）：`git clone --depth 1 --branch cursor/daytap-watch-app-60a0 https://origin.cursor.com/chris-cui/DayTap.git`

---

## 一句话现状

- 产品名：**DayTap**（自研 Apple Watch 开麦小工具）
- 源码仓：GitHub [`flicy/DayTap`](https://github.com/flicy/DayTap)（组员克隆用这个）。Origin 备用：[`chris-cui/DayTap`](https://cursor.com/codebase/chris-cui/DayTap)（PRIVATE）
- 可用工程在 PR：[`#1` 分支 `cursor/daytap-watch-app-60a0`](https://cursor.com/codebase/chris-cui/DayTap/pull/1)
- **没有** `.ipa`、**没有** TestFlight、**没有** App Store
- 装机方式：Mac 上用 Xcode 编译并装到「已配对的 iPhone + Apple Watch」
- 工程文件：`apps/DayTap/DayTap.xcodeproj`（没有单独的 `.xcworkspace`）

---

## 你需要准备什么

| 必备 | 说明 |
|------|------|
| Mac | 装好 **Xcode 15+**（App Store 搜 Xcode） |
| Apple ID | 免费账号即可侧载（约 **7 天**过期，过期再 Run 一次续签） |
| iPhone | 与 Watch 已配对；开发机要用线连 Mac |
| Apple Watch | 解锁佩戴；与 iPhone 在身边 |
| 仓权限 | 能打开 GitHub `flicy/DayTap`，或 Origin 备用仓 |

模拟器**测不了**手表→手机传文件，必须真机。

---

## 装机步骤（照做）

1. **拉代码（浅克隆）**  
   不要拉全历史。在终端执行：  
   `git clone --depth 1 --branch cursor/daytap-watch-app-60a0 https://github.com/flicy/DayTap.git`  
   Origin 备用：`git clone --depth 1 --branch cursor/daytap-watch-app-60a0 https://origin.cursor.com/chris-cui/DayTap.git`  
   网页对照可先打开 [PR #1](https://cursor.com/codebase/chris-cui/DayTap/pull/1)。GitHub 上 `main` 与分支 `cursor/daytap-watch-app-60a0` 是同一版。

2. **打开工程**  
   用 Xcode 打开：`apps/DayTap/DayTap.xcodeproj`  
   （没有单独的 `.xcworkspace`）

3. **签名**  
   - 选中蓝色工程 **DayTap**  
   - Target **DayTap**（iPhone）：Signing & Capabilities → 勾选 Automatically manage signing → Team 选你的 Apple ID  
   - Bundle id 默认 `com.chriscui.daytap`；若提示被占用，改成你自己的唯一 id（例如 `com.你的名字.daytap`）  
   - Target **DayTap Watch App**：同样选 Team；Watch 的 bundle id 必须是 `<iphone-id>.watchkitapp`  
   - 若改了 iPhone bundle id，同步改 `apps/DayTap/DayTapWatch/Info.plist` 里的 `WKCompanionAppBundleIdentifier`（写成 iPhone 的 id，不要带 `.watchkitapp`）

4. **连真机**  
   - iPhone 用线连 Mac，解锁，若提示「信任此电脑」点信任  
   - 手表戴上并解锁，靠近 iPhone

5. **第一次 Run**  
   - Scheme 选 **DayTap**  
   - 目标选 **你的真机 iPhone**（不要选 Simulator）  
   - 点 Run（▶）  
   - 若 iPhone 提示开发者未信任：设置 → 通用 → VPN 与设备管理 → 信任该开发者 → 再 Run 一次

6. **手表上没有图标时**  
   - Scheme 改成 **DayTap Watch App**，目标选你的 Watch，再 Run 一次  
   - 然后再用 **DayTap** Scheme 对 iPhone Run 一次，保证手机收件箱 App 也在

7. **冒烟测**  
   - 手表：允许麦克风 → 点 **开始** → 说话 → **停止**  
   - iPhone：打开 DayTap 列表，应出现录音；点 **分享** 可导出  
   - 列表一直空：两机靠近、两边都打开 DayTap，手表点 **再传一次**

签名、传文件和产品边界的更细说明在 [`daytap-watch-app.md`](daytap-watch-app.md)。

---

## 常见坑

- **免费 Apple ID 约 7 天过期**：过期后 App 打不开，用同一台 Mac 再 Run 一次即可  
- **必须有很薄的 iPhone Companion**：当前 MVP 靠 WatchConnectivity 把音频传到手机；不是「只装手表、完全不装手机 App」  
- **黑客松可以说手机端先用网页看板**：那是路演形态；**第一次装上手表仍然要走上面的 Xcode 侧载**  
- Linux / 云端编不出可装真机的 Watch 包；以 Mac 签装为准

---

## 组员怎么一起改代码

1. 拿到仓读/写权限（Origin 邀请 Cursor 账号，或 GitHub 协作仓邀请）  
2. 从 `cursor/daytap-watch-app-60a0`（或合并后的 `main`）拉分支开发  
3. **每人自己的 Mac + 自己的 Apple ID** 签装到自己的设备——不能把别人签好的包直接拷给你装  
4. 改完提 PR，写清：改了什么、是否真机测过录音与回传

---

## 协作账号（本轮）

- 待加协作者 GitHub：`guanlili` → https://github.com/guanlili  
- 组员克隆：https://github.com/flicy/DayTap （分支 `cursor/daytap-watch-app-60a0`，与 `main` 同一版）  
- Origin 备用：https://cursor.com/codebase/chris-cui/DayTap

有问题先在队内同步「卡在第几步 + Xcode 报错原文」。
