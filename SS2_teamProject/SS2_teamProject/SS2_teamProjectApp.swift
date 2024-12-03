import SwiftUI
import FirebaseCore

// Firebase 초기화를 위한 AppDelegate 정의
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct SS2_teamProjectApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // 전역 상태 관리 객체
    @StateObject private var navigationManager = NavigationManager()


    var body: some Scene {
        WindowGroup {
            NavigationView {
                RootView() // RootView로 초기 화면 설정
                    .environmentObject(navigationManager)
            }
        }
    }
}
