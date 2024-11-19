import SwiftUI

struct SettingView: View {
    @State private var isPushNotificationEnabled: Bool = true // 푸시 알림 상태 관리

    var body: some View {
        NavigationView {
            List {
                // 사용자 계정 관리 섹션
                Section(header: Text("사용자 계정 관리")) {
                    NavigationLink(destination: UserInfoSettingsView()) {
                        Text("사용자 정보 관리")
                    }
                }

                // 알림 설정 섹션
                Section(header: Text("알림 설정")) {
                    Toggle("푸시 알림", isOn: $isPushNotificationEnabled)
                        .onChange(of: isPushNotificationEnabled) { newValue in
                            print("푸시 알림 설정 변경됨: \(newValue)")
                            updatePushNotificationStatus(newValue)
                        }
                }

                // 앱 개인화 설정 섹션
               

                // 개인정보 보호 섹션
                Section(header: Text("개인정보 보호")) {
                    /* NavigationLink(destination: PrivacyPolicyView()) {
                        Text("개인정보 정책")
                    }*/
                }

            

                // 지원 및 도움말 섹션
                Section(header: Text("지원 및 도움말")) {
                    NavigationLink(destination: ContactSupportView()) {
                        Text("문의하기")
                    }
                }

                // 기타 섹션
                Section(header: Text("기타")) {
                    NavigationLink(destination: NoticesView()) {
                        Text("공지사항")
                    }
                    NavigationLink(destination: LanguageSettingsView()) {
                        Text("언어 설정")
                    }
                    NavigationLink(destination: TermsOfServiceView()) {
                        Text("이용약관")
                    }
                    Text("앱 버전: \(getAppVersion())") // 앱 버전 표시
                        .foregroundColor(.gray)
                    Button(action: {
                        print("로그아웃 클릭됨")
                        // 로그아웃 로직 추가
                    }) {
                        Text("로그아웃")
                            .foregroundColor(.red)
                    }
                    Button(action: {
                        print("탈퇴하기 클릭됨")
                        // 탈퇴 로직 추가
                    }) {
                        Text("탈퇴하기")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("환경설정")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // 푸시 알림 상태 변경 로직
    func updatePushNotificationStatus(_ isEnabled: Bool) {
        if isEnabled {
            print("푸시 알림 활성화됨")
            // UNUserNotificationCenter를 사용한 푸시 알림 권한 요청 로직 추가 가능
        } else {
            print("푸시 알림 비활성화됨")
            // 비활성화 처리 로직 추가 가능
        }
    }

    // 앱 버전 가져오기
    func getAppVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
}



// 언어 설정 뷰
struct LanguageSettingsView: View {
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "한국어"
    let languages = ["한국어", "English", "日本語", "中文"]

    var body: some View {
        VStack {
            Picker("언어 선택", selection: $selectedLanguage) {
                ForEach(languages, id: \.self) { language in
                    Text(language)
                }
            }
            .pickerStyle(.wheel)
            .padding()

            Text("현재 언어: \(selectedLanguage)")
                .padding()

            Spacer()
        }
        .navigationTitle("언어 설정")
    }
}

#Preview {
    SettingView()
}
