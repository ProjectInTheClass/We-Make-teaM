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
    // Firebase 초기화를 위해 AppDelegate 연결
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // 전역 상태 관리 객체
    @StateObject private var navigationManager = NavigationManager()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                LoginView() // 초기 화면을 LoginView로 설정
                    .environmentObject(navigationManager) // 네비게이션 관리 객체를 환경에 주입
            }
        }
    }
}
