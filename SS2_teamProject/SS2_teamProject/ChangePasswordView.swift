import SwiftUI

struct ChangePasswordView: View {
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""

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
        .padding()
        .navigationTitle("비밀번호 변경")
    }
}

