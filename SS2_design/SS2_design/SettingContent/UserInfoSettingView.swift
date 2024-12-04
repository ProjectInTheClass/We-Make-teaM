import SwiftUI

struct UserInfoSettingsView: View {
    @State private var selectedTab: Tab = .profile
    @State private var nickname: String = ""
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""

    enum Tab {
        case profile, password
    }

    var body: some View {
        VStack {
            // 상단 탭 전환
            Picker("설정", selection: $selectedTab) {
                Text("프로필 관리").tag(Tab.profile)
                Text("비밀번호 변경").tag(Tab.password)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            // 선택된 탭에 따라 다른 뷰를 표시
            if selectedTab == .profile {
                ProfileSettingsView(nickname: $nickname)
            } else if selectedTab == .password {
                PasswordSettingsView(currentPassword: $currentPassword, newPassword: $newPassword, confirmPassword: $confirmPassword)
            }
            
            Spacer()
        }
        .navigationTitle("사용자 정보 관리")
        .padding()
    }
}

// 프로필 관리 뷰
struct ProfileSettingsView: View {
    @Binding var nickname: String

    var body: some View {
        VStack {
            TextField("닉네임 입력", text: $nickname)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("저장") {
                print("닉네임 저장됨: \(nickname)")
                // 저장 로직 추가
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}

// 비밀번호 변경 뷰
struct PasswordSettingsView: View {
    @Binding var currentPassword: String
    @Binding var newPassword: String
    @Binding var confirmPassword: String

    var body: some View {
        VStack {
            SecureField("현재 비밀번호", text: $currentPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("새 비밀번호", text: $newPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("새 비밀번호 확인", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("변경하기") {
                if newPassword == confirmPassword {
                    print("비밀번호 변경됨")
                    // 비밀번호 변경 로직 추가
                } else {
                    print("비밀번호가 일치하지 않음")
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}

#Preview {
    UserInfoSettingsView()
}

