import SwiftUI

struct SettingView: View {
    var body: some View {
        NavigationView {
            List {
                // 사용자 계정 관리 섹션
                Section(header: Text("사용자 계정 관리")) {
                    NavigationLink(destination: ProfileSettingsView()) {
                        Text("프로필 관리")
                    }
                    NavigationLink(destination: ChangePasswordView()) {
                        Text("비밀번호 변경")
                    }
                    Button(action: {
                        print("로그아웃 클릭됨")
                    }) {
                        Text("로그아웃")
                            .foregroundColor(.red)
                    }
                }
                
                // 알림 설정 섹션
                Section(header: Text("알림 설정")) {
                    NavigationLink(destination: NotificationSettingsView()) {
                        Text("푸시 알림 설정")
                    }
                   
                }
                
                // 앱 개인화 설정 섹션
                Section(header: Text("앱 개인화 설정")) {
                    NavigationLink(destination: ThemeSettingsView()) {
                        Text("테마 변경")
                    }
                   
                }
                
                // 개인정보 보호 섹션
                Section(header: Text("개인정보 보호")) {
                   /* NavigationLink(destination: PrivacyPolicyView()) {
                        Text("개인정보 정책")
                    }*/
                    NavigationLink(destination: DataManagementView()) {
                        Text("데이터 관리")
                    }
                }
                
                // 사용자 동의 관리 섹션
                Section(header: Text("사용자 동의 관리")) {
                    NavigationLink(destination: PermissionsView()) {
                        Text("푸시 알림 권한")
                    }
                   
                }
                
                // 지원 및 도움말 섹션
                Section(header: Text("지원 및 도움말")) {
                    /*NavigationLink(destination: FAQView()) {
                        Text("도움말/FAQ")
                    }*/
                    NavigationLink(destination: ContactSupportView()) {
                        Text("문의하기")
                    }
                }
                
                // 일반 설정 섹션
                Section(header: Text("일반 설정")) {
                    NavigationLink(destination: CacheManagementView()) {
                        Text("캐시 데이터 관리")
                    }
                    /*NavigationLink(destination: ResetSettingsView()) {
                        Text("기본 설정 초기화")
                    }*/
                }
                
                // 기타 섹션
                
                Section(header: Text("기타")) {
                    //NavigationLink(destination: AppInfoView()) {
                      //  Text("앱 정보")
                    }
                    Button(action: {
                        print("앱 평가하기 클릭됨")
                    }) {
                        Text("앱 평가하기")
                    }
                }
            }
            .navigationTitle("환경설정")
            .navigationBarTitleDisplayMode(.inline)
        }
    }


#Preview {
    SettingView()
}
