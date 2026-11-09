import SwiftUI

/// 启动时就挂上 WatchConnectivity，避免系统在后台送来文件时还没有委托。
final class DayTapAppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        PhoneLink.shared.activate()
        DayTapLog.link.info("iPhone application launched")
        return true
    }
}

@main
struct DayTapApp: App {
    @UIApplicationDelegateAdaptor(DayTapAppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            RecordingListView()
        }
    }
}
