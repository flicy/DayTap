import AVFoundation
import Combine
import Foundation
import WatchKit

/// 表盘上那一个按钮背后的状态。界面只跟它说话。
/// 所有方法都从主线程调用（按钮、计时器、场景变化）。
final class WatchModel: ObservableObject {
    @Published var isRecording = false
    @Published var elapsed: TimeInterval = 0
    @Published var level: Float = 0
    @Published var status = "点一下开始"
    @Published var detail = "结束后音频传到配对的 iPhone。手表不连接得到。"
    @Published var permissionDenied = false

    private let capture = AudioCapture()
    private let link = WatchLink.shared
    private var timer: Timer?
    private var startedAt: Date?
    private var recordingID: String?
    private var interruptionObserver: NSObjectProtocol?

    init() {
        link.onChange = { [weak self] in
            self?.detail = self?.link.statusText ?? ""
        }
        detail = link.statusText
        interruptionObserver = NotificationCenter.default.addObserver(
            forName: AVAudioSession.interruptionNotification,
            object: AVAudioSession.sharedInstance(),
            queue: .main
        ) { [weak self] note in
            self?.handleInterruption(note)
        }
    }

    deinit {
        if let interruptionObserver {
            NotificationCenter.default.removeObserver(interruptionObserver)
        }
    }

    func onAppear() {
        switch capture.permissionState() {
        case .denied:
            permissionDenied = true
            status = "需要麦克风权限"
        case .granted:
            permissionDenied = false
        case .undetermined:
            permissionDenied = false
        @unknown default:
            permissionDenied = false
        }
        link.activate()
    }

    /// 再交一次还没被 iPhone 确认的文件。不重新开麦。
    func retry() {
        link.activate()
        link.retryPending(reason: "manual")
        detail = link.statusText
    }

    func onActive() {
        // 回到前台时，把上次没传完的再交一次。不在这里自动重新开麦。
        link.retryPending(reason: "foreground")
        if isRecording, !capture.isRecording {
            // 系统把录音停掉了，但界面还以为在录。把已有文件送出去。
            finish(reason: "录音被系统停下，已保存并排队")
        }
    }

    func toggle() {
        if isRecording {
            finish(reason: nil)
        } else {
            begin()
        }
    }

    /// 场景进入后台：先停、再排队。不假装手腕放下还能继续录。
    func stopBecauseBackgrounded() {
        guard isRecording else { return }
        finish(reason: "DayTap 离开前台，已停止并排队传到 iPhone")
    }

    private func begin() {
        let startCapture = { [weak self] in
            guard let self else { return }
            let id = UUID().uuidString
            let url = self.link.library.fileURL(id: id)
            do {
                try self.capture.start(fileURL: url)
            } catch {
                self.status = error.localizedDescription
                DayTapLog.recorder.error("start failed \(error.localizedDescription, privacy: .public)")
                try? FileManager.default.removeItem(at: url)
                return
            }
            self.recordingID = id
            self.startedAt = Date()
            self.elapsed = 0
            self.level = 0
            self.isRecording = true
            self.permissionDenied = false
            self.status = "正在录音"
            self.detail = "点停止后保存，并传给 iPhone"
            WKInterfaceDevice.current().play(.start)
            self.startTimer()
        }

        switch capture.permissionState() {
        case .granted:
            startCapture()
        case .denied:
            permissionDenied = true
            status = "请在手表设置里允许 DayTap 使用麦克风"
        case .undetermined:
            capture.requestPermission { [weak self] granted in
                guard let self else { return }
                if granted {
                    self.permissionDenied = false
                    startCapture()
                } else {
                    self.permissionDenied = true
                    self.status = "没有麦克风权限，没法录"
                }
            }
        @unknown default:
            capture.requestPermission { granted in
                if granted { startCapture() }
            }
        }
    }

    private func finish(reason: String?) {
        let duration = capture.stop() ?? elapsed
        stopTimer()
        isRecording = false
        level = 0
        WKInterfaceDevice.current().play(.stop)

        guard let id = recordingID, let startedAt else {
            status = "没有可发送的录音"
            recordingID = nil
            return
        }
        let url = link.library.fileURL(id: id)
        let size = (try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize) ?? 0
        guard size > 0 else {
            try? FileManager.default.removeItem(at: url)
            status = "录音是空的，没有发送"
            DayTapLog.recorder.error("empty recording \(id, privacy: .public)")
            recordingID = nil
            self.startedAt = nil
            return
        }
        let record = RecordingRecord(
            id: id,
            createdAt: startedAt,
            durationSeconds: duration,
            byteCount: size,
            state: .pending,
            lastError: nil,
            updatedAt: Date()
        )
        link.library.upsert(record)
        link.enqueue(id: id)
        status = reason ?? "已保存，正在传给 iPhone"
        if reason == nil {
            detail = link.statusText
        }
        recordingID = nil
        self.startedAt = nil
    }

    private func startTimer() {
        timer?.invalidate()
        let timer = Timer(timeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self else { return }
            guard let startedAt = self.startedAt else { return }
            self.elapsed = Date().timeIntervalSince(startedAt)
            self.level = self.capture.currentLevel()
        }
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    /// 来电、Siri、闹钟会抢麦克风。被打断就结束这一条并发送，不在通话结束后偷偷接着录。
    private func handleInterruption(_ note: Notification) {
        guard isRecording else { return }
        let raw = (note.userInfo?[AVAudioSessionInterruptionTypeKey] as? NSNumber)?.uintValue
        let began = raw == nil || raw == AVAudioSession.InterruptionType.began.rawValue
        guard began else { return }
        DayTapLog.recorder.info("interrupted, saving partial take")
        finish(reason: "录音被打断，已保存并排队传到 iPhone")
    }
}
