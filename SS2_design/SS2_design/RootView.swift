import SwiftUI
import FirebaseAuth
import GoogleSignIn

struct RootView: View {
    @State private var isLoggedIn: Bool? = nil // 로그인 상태 (초기 상태: nil)
    
    var body: some View {
        Group {
            if let isLoggedIn = isLoggedIn {
                if isLoggedIn {
                    ContentView() // 자동 로그인 성공 시 메인 화면으로 이동
                } else {
                    LoginView() // 로그아웃 상태라면 로그인 화면으로 이동
                }
            } else {
                ProgressView("로딩 중...") // 로그인 상태를 확인하는 동안 로딩 화면 표시
            }
        }
        .onAppear {
            checkLoginStatus()
        }
    }
    
    private func checkLoginStatus() {
        // Firebase 인증 상태 확인
        if Auth.auth().currentUser != nil {
            isLoggedIn = true
        }
        // GoogleSignIn 상태 확인
        else if GIDSignIn.sharedInstance.currentUser != nil {
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
    }
}
