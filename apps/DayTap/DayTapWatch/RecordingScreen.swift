import SwiftUI

/// 手表上只有一个动作：开始，或停止并发送。
struct RecordingScreen: View {
    @ObservedObject var model: WatchModel
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ScrollView {
        VStack(spacing: 8) {
            Text("DayTap")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(model.isRecording ? DayTapFormat.clock(model.elapsed) : "准备好了")
                .font(.system(size: 28, weight: .semibold, design: .rounded))
                .monospacedDigit()
                .minimumScaleFactor(0.6)

            levelBar

            Button(action: model.toggle) {
                Text(model.isRecording ? "停止" : "开始")
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(model.isRecording ? .red : Color(red: 0.89, green: 0.36, blue: 0.27))
            .disabled(model.permissionDenied && !model.isRecording)
            .accessibilityIdentifier("daytap.record.toggle")
            .accessibilityLabel(model.isRecording ? "停止录音并发送到 iPhone" : "开始录音")

            if !model.isRecording {
                Button("再传一次", action: model.retry)
                    .buttonStyle(.bordered)
                    .font(.caption2)
                    .accessibilityIdentifier("daytap.record.retry")
            }

            Text(model.status)
                .font(.footnote)
                .multilineTextAlignment(.center)
                .lineLimit(3)

            Text(model.detail)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(3)
        }
        .padding(.horizontal, 6)
        }
        .onAppear(perform: model.onAppear)
        .onChange(of: scenePhase) { _, phase in
            switch phase {
            case .active:
                model.onActive()
            case .background:
                model.stopBecauseBackgrounded()
            case .inactive:
                break
            @unknown default:
                break
            }
        }
    }

    private var levelBar: some View {
        Capsule()
            .fill(Color.white.opacity(0.15))
            .frame(height: 6)
            .overlay(alignment: .leading) {
                Capsule()
                    .fill(model.isRecording ? Color.red : Color.white.opacity(0.35))
                    .scaleEffect(
                        x: CGFloat(model.isRecording ? max(model.level, 0.08) : 0.08),
                        y: 1,
                        anchor: .leading
                    )
            }
            .accessibilityHidden(true)
    }
}
