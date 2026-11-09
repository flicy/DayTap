import SwiftUI
import UniformTypeIdentifiers

/// 把 m4a 交给系统分享表。得到大脑、飞书、文件、隔空投送只要注册了音频类型，就会出现在表里。
struct DayTapAudioFile: Transferable {
    let url: URL

    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .mpeg4Audio) { item in
            SentTransferredFile(item.url)
        } importing: { received in
            DayTapAudioFile(url: received.file)
        }
    }
}

/// 「存到文件」用的文档包装。只导出，不从外部打开。
struct M4AFile: FileDocument {
    static var readableContentTypes: [UTType] { [.mpeg4Audio] }

    let url: URL

    init(url: URL) {
        self.url = url
    }

    init(configuration: ReadConfiguration) throws {
        throw CocoaError(.fileReadUnsupportedScheme)
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        try FileWrapper(url: url, options: .immediate)
    }
}
