import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RegisterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var nickname: String = ""
    @State private var errorMessage: String = ""
    @State private var isLoading = false
    @Environment(\.dismiss) var dismiss // 회원가입 후 로그인 화면으로 돌아가기

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            // 앱 로고
            Image(systemName: "person.badge.plus")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.green)

            // 이메일 입력
            TextField("이메일", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .padding(.horizontal)

            // 닉네임 입력
            TextField("닉네임", text: $nickname)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            // 비밀번호 입력
            SecureField("비밀번호", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            // 비밀번호 확인 입력
            SecureField("비밀번호 확인", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            // 오류 메시지
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
            }

            // 회원가입 버튼
            Button(action: register) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8)
                } else {
                    Text("회원가입")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            .disabled(isLoading) // 로딩 중 버튼 비활성화

            Spacer()
        }
        .padding()
        .navigationTitle("회원가입")
        .navigationBarTitleDisplayMode(.inline)
    }

    func register() {
        // 유효성 검사
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty, !nickname.isEmpty else {
            errorMessage = "모든 필드를 입력하세요."
            return
        }

        guard password == confirmPassword else {
            errorMessage = "비밀번호가 일치하지 않습니다."
            return
        }

        guard password.count >= 6 else {
            errorMessage = "비밀번호는 6자 이상이어야 합니다."
            return
        }

        // Firebase 회원가입 처리
        isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            isLoading = false
            if let error = error {
                errorMessage = "회원가입 실패: \(error.localizedDescription)"
            } else if let user = result?.user {
                saveUserToFirestore(user: user)
            }
        }
    }

    func saveUserToFirestore(user: User) {
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).setData([
            "email": email,
            "nickname": nickname,
            "createdAt": Timestamp(),
            "score": 50 // 기본값 50
        ]) { error in
            if let error = error {
                errorMessage = "사용자 데이터 저장 실패: \(error.localizedDescription)"
            } else {
                dismiss() // 성공적으로 저장 후 화면 닫기
            }
        }
    }
}

#Preview {
    RegisterView()
}
