import SwiftUI

struct SettingView: View {
    @State private var isPushNotificationEnabled: Bool = true
    @State private var showAlert = false // 팝업 표시 여부
    @State private var alertTitle = "" // 팝업 제목
    @State private var alertMessage = "" // 팝업 메시지
    @State private var isLogout = false // 로그인 화면으로 이동 여부
    @State private var passwordInput = "" // 탈퇴 시 비밀번호 입력
    
    var body: some View {
        NavigationView {
            List {
                // 사용자 계정 관리 섹션
                Section(header: Text("사용자 계정 관리")) {
                    NavigationLink(destination: UserInfoSettingsView()) {
                        HStack {
                            Image(systemName: "person.circle")
                                .foregroundColor(.yellow)
                            Text("사용자 정보 관리")
                        }
                    }
                }
                
                // 알림 설정 섹션
                Section(header: Text("알림 설정")) {
                    Toggle(isOn: $isPushNotificationEnabled) {
                        HStack {
                            Image(systemName: "bell.badge")
                                .foregroundColor(.yellow)
                            Text("푸시 알림")
                        }
                    }
                    .onChange(of: isPushNotificationEnabled) { newValue in
                        print("푸시 알림 설정 변경됨: \(newValue)")
                        // 여기서 알림 설정을 저장하거나 업데이트하는 로직을 추가할 수 있습니다.
                    }
                }
                
                // 지원 및 도움말 섹션
                Section(header: Text("지원 및 도움말")) {
                    NavigationLink(destination: ContactSupportView()) {
                        HStack {
                            Image(systemName: "questionmark.circle")
                                .foregroundColor(.yellow)
                            Text("문의하기")
                        }
                    }
                }
                
                // 기타 섹션
                Section(header: Text("기타")) {
                    NavigationLink(destination: NoticesView()) {
                        HStack {
                            ZStack {
                                Image(systemName: "megaphone.fill")
                                    .foregroundColor(.yellow)
                            }
                            Text("공지사항")
                        }
                    }
                    
                    NavigationLink(destination: TermsOfServiceView()) {
                        HStack {
                            Image(systemName: "doc.text.fill")
                                .foregroundColor(.yellow)
                            Text("이용약관")
                        }
                    }
                    
                    HStack {
                        Image(systemName: "info.circle")
                            .foregroundColor(.gray)
                        Text("앱 버전: \(getAppVersion())")
                            .foregroundColor(.gray)
                    }
                    
                    // 로그아웃 버튼
                    Button(action: {
                        logOut()
                    }) {
                        HStack {
                            Image(systemName: "arrow.backward.circle")
                                .foregroundColor(.red)
                            Text("로그아웃")
                                .foregroundColor(.red)
                                .fontWeight(.semibold)
                        }
                    }
                    
                    // 탈퇴하기 버튼
                    Button(action: {
                        showPasswordAlert()
                    }) {
                        HStack {
                            Image(systemName: "trash.circle")
                                .foregroundColor(.red)
                            Text("탈퇴하기")
                                .foregroundColor(.red)
                                .fontWeight(.semibold)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("환경설정")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $showAlert) {
                switch alertTitle {
                case "비밀번호 확인":
                    return Alert(
                        title: Text(alertTitle),
                        message: Text(alertMessage),
                        primaryButton: .default(Text("확인"), action: {
                            deleteAccount()
                        }),
                        secondaryButton: .cancel(Text("취소"), action: {
                            passwordInput = ""
                        })
                    )
                default:
                    return Alert(
                        title: Text(alertTitle),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("확인"), action: {
                            if alertTitle == "탈퇴 완료" || alertTitle == "로그아웃 완료" {
                                closePopupAndNavigate()
                            }
                        })
                    )
                }
            }
            .fullScreenCover(isPresented: $isLogout) {
                NavigationView {
                    LoginView() // 로그인 화면으로 이동
                }
            }
        }
    }
    
    // 앱 버전 가져오기
    func getAppVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
    
    // 로그아웃 로직 (Firebase 없이 단순히 알림 표시 및 로그인 화면으로 이동)
    func logOut() {
        alertTitle = "로그아웃 완료"
        alertMessage = "성공적으로 로그아웃되었습니다."
        showAlert = true
    }
    
    // 탈퇴 로직 (Firebase 없이 단순히 알림 표시)
    func deleteAccount() {
        // 실제 계정 삭제는 서버와 연동되지 않으므로 로컬 상태만 변경
        alertTitle = "탈퇴 완료"
        alertMessage = "성공적으로 계정이 삭제되었습니다."
        showAlert = true
    }
    
    // 팝업 종료 후 로그인 화면 이동
    func closePopupAndNavigate() {
        showAlert = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isLogout = true // 팝업 종료 후 로그인 화면으로 이동
        }
    }

    // 비밀번호 확인 팝업 표시
    func showPasswordAlert() {
        alertTitle = "비밀번호 확인"
        alertMessage = "계정을 삭제하려면 비밀번호를 입력해주세요."
        showAlert = true
    }
}

#Preview {
    SettingView()
}
