import Foundation

enum DayTapFormat {
    /// 录音计时，例如 `12:05`。
    static func clock(_ seconds: TimeInterval) -> String {
        let total = max(0, Int(seconds.rounded(.down)))
        return String(format: "%d:%02d", total / 60, total % 60)
    }

    static func bytes(_ count: Int) -> String {
        let value = Double(max(0, count))
        if value < 1024 {
            return "\(count) B"
        }
        if value < 1024 * 1024 {
            return String(format: "%.0f KB", value / 1024)
        }
        return String(format: "%.1f MB", value / 1024 / 1024)
    }

    /// 分享出去时用的文件名，方便在得到或文件 App 里辨认。不参与传输协议。
    static func shareFilename(createdAt: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyyMMdd-HHmmss"
        return "DayTap-\(formatter.string(from: createdAt)).m4a"
    }
}
