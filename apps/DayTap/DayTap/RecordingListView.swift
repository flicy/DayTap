import SwiftUI
import UniformTypeIdentifiers

/// iPhone 上的收件箱。不做录音。
/// 分享：Track 2 交给得到大脑，或 Track 1 交给飞书妙记 / 文件 / 隔空投送到 Mac。
struct RecordingListView: View {
    @ObservedObject private var link = PhoneLink.shared
    @ObservedObject private var library = PhoneLink.shared.library
    @Environment(\.scenePhase) private var scenePhase

    @State private var exportURL: URL?
    @State private var exportName = "DayTap.m4a"
    @State private var showExporter = false
    @State private var banner: String?

    var body: some View {
        NavigationStack {
            Group {
                if library.records.isEmpty {
                    emptyState
                } else {
                    list
                }
            }
            .navigationTitle("DayTap")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Text(link.sessionReady ? "通道就绪" : "未连接")
                        .font(.caption)
                        .foregroundStyle(link.sessionReady ? .green : .secondary)
                }
            }
        }
        .fileExporter(
            isPresented: $showExporter,
            document: exportURL.map { M4AFile(url: $0) },
            contentType: .mpeg4Audio,
            defaultFilename: exportName
        ) { result in
            if case .failure(let error) = result {
                banner = error.localizedDescription
                DayTapLog.library.error("file export failed \(error.localizedDescription, privacy: .public)")
            }
        }
        .onOpenURL { url in
            banner = "已打开 DayTap 录音列表"
            DayTapLog.link.info("open url \(url.absoluteString, privacy: .public)")
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                link.activate()
            }
        }
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("还没有手表录音")
                .font(.title2.bold())
            Text("在 Apple Watch 上打开 DayTap，点一次「开始」，再点「停止」。音频会出现在这里。")
            Text(link.status)
                .font(.footnote)
                .foregroundStyle(.secondary)
            trackNote
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private var list: some View {
        List {
            Section {
                Text(link.status)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                if let banner {
                    Text(banner)
                        .font(.footnote)
                }
                trackNote
            }
            Section("最近录音") {
                ForEach(library.records) { record in
                    row(record)
                }
            }
        }
    }

    private func row(_ record: RecordingRecord) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(record.createdAt.formatted(date: .abbreviated, time: .shortened))
                .font(.body.weight(.semibold))
            Text("\(DayTapFormat.clock(record.durationSeconds)) · \(DayTapFormat.bytes(record.byteCount)) · m4a")
                .font(.caption)
                .foregroundStyle(.secondary)
            HStack(spacing: 16) {
                let fileURL = link.library.fileURL(id: record.id)
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    ShareLink(
                        item: DayTapAudioFile(url: fileURL),
                        preview: SharePreview(
                            DayTapFormat.shareFilename(createdAt: record.createdAt),
                            image: Image(systemName: "waveform")
                        )
                    ) {
                        Label("分享", systemImage: "square.and.arrow.up")
                    }
                    .accessibilityIdentifier("daytap.share.\(record.id)")
                }
                Button {
                    prepareExport(record)
                } label: {
                    Label("存到文件", systemImage: "folder")
                }
            }
            .font(.callout)
            .buttonStyle(.borderless)
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("daytap.recording.\(record.id)")
    }

    private var trackNote: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("手表只负责录音，不连接得到。")
            Text("Track 1：分享或「存到文件」后，用飞书妙记、快捷指令转写，或把文件送到 Mac 做系统转写。文字再贴给 Bot。不要把这条音频送进得到。")
            Text("Track 2：点「分享」，选得到大脑；或在得到里用「导入音视频」选这个 m4a。得到只在这台 iPhone 上。")
            Text("在「文件」App 里打开：我的 iPhone → DayTap。链接 daytap://recordings 会回到这个列表。")
            Text("这是开发版，还不能从 App Store 安装。表上没装好时，用手机上的得到、语音备忘录或飞书妙记录（Track 0）。")
        }
        .font(.caption)
        .foregroundStyle(.secondary)
    }

    private func prepareExport(_ record: RecordingRecord) {
        guard let url = link.shareFileURL(for: record) else {
            banner = "找不到这条音频文件"
            return
        }
        exportURL = url
        exportName = DayTapFormat.shareFilename(createdAt: record.createdAt)
        showExporter = true
    }
}
