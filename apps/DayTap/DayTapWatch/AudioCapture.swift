import AVFoundation
import Foundation

/// 手表前台录音。
/// 使用 `AVAudioRecorder` 写成单声道 AAC `.m4a`，方便 iPhone 分享给飞书妙记或得到大脑。
/// 不使用延长运行会话：那些会话类型对不上「上一节课」，滥用有审核风险。屏幕熄灭或回到后台时由界面层停止并保存。
final class AudioCapture {
    private var recorder: AVAudioRecorder?
    private(set) var fileURL: URL?

    var isRecording: Bool {
        recorder?.isRecording ?? false
    }

    func permissionState() -> AVAudioApplication.recordPermission {
        AVAudioApplication.shared.recordPermission
    }

    func requestPermission(completion: @escaping (Bool) -> Void) {
        AVAudioApplication.requestRecordPermission { granted in
            DispatchQueue.main.async {
                DayTapLog.recorder.info("microphone permission granted=\(granted)")
                completion(granted)
            }
        }
    }

    func start(fileURL: URL) throws {
        try FileManager.default.createDirectory(
            at: fileURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        let session = AVAudioSession.sharedInstance()
        // 先试只录音。个别系统拒绝 `.record` 时退回 `.playAndRecord`，仍只把文件写到本地。
        do {
            try session.setCategory(.record, mode: .default, options: [])
        } catch {
            DayTapLog.recorder.error("record category failed, falling back: \(error.localizedDescription, privacy: .public)")
            try session.setCategory(.playAndRecord, mode: .default, options: [])
        }
        try session.setActive(true)

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 22_050,
            AVNumberOfChannelsKey: 1,
            AVEncoderBitRateKey: 48_000,
            AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
        ]
        let recorder = try AVAudioRecorder(url: fileURL, settings: settings)
        recorder.isMeteringEnabled = true
        recorder.prepareToRecord()
        guard recorder.record() else {
            throw CaptureError.failedToStart
        }
        self.recorder = recorder
        self.fileURL = fileURL
        DayTapLog.recorder.info("recording started \(fileURL.lastPathComponent, privacy: .public)")
    }

    /// 停止并返回时长。文件留在 `fileURL`，调用方负责入队传输。
    func stop() -> TimeInterval? {
        guard let recorder, let fileURL else { return nil }
        let duration = recorder.currentTime
        recorder.stop()
        self.recorder = nil
        self.fileURL = nil
        try? AVAudioSession.sharedInstance().setActive(false, options: [.notifyOthersOnDeactivation])
        DayTapLog.recorder.info("recording stopped \(fileURL.lastPathComponent, privacy: .public) duration=\(duration)")
        return duration
    }

    /// 0...1，给界面上的音量条。没有在录就返回 0。
    func currentLevel() -> Float {
        guard let recorder, recorder.isRecording else { return 0 }
        recorder.updateMeters()
        let db = recorder.averagePower(forChannel: 0)
        let clamped = max(-50, min(0, db))
        return (clamped + 50) / 50
    }

    enum CaptureError: LocalizedError {
        case failedToStart

        var errorDescription: String? {
            switch self {
            case .failedToStart:
                return "录音没有开始。请允许麦克风，并让 DayTap 留在前台。"
            }
        }
    }
}
