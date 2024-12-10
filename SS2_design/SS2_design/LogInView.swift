import SwiftUI
//import FirebaseAuth

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @State private var isShowingMainView = false
    @State private var isLoading = false // 로딩 상태 추가
    @State private var showPassword = false // 비밀번호 보이기/숨기기

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            // 앱 로고
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)

            // 이메일 입력
            TextField("이메일", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .padding(.horizontal)

            // 비밀번호 입력
            ZStack {
                if showPassword {
                    TextField("비밀번호", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                } else {
                    SecureField("비밀번호", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                HStack {
                    Spacer()
                    Button(action: {
                        showPassword.toggle()
                    }) {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                            .padding(.trailing, 20)
                    }
                }
            }

            // 오류 메시지
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
            }

            // 로그인 버튼
            Button(action: login) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                } else {
                    Text("로그인")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            .disabled(isLoading)

            // 회원가입으로 이동 버튼
            NavigationLink(destination: RegisterView()) {
                Text("계정이 없으신가요? 회원가입")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("로그인")
        .fullScreenCover(isPresented: $isShowingMainView) {
            ContentView() // 로그인 성공 후 메인 화면으로 이동
        }
    }

    func login() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "모든 필드를 입력하세요."
            return
        }

        isLoading = true
        //Auth.auth().signIn(withEmail: email, password: password) { result, error in
            //isLoading = false
            //if let error = error {
                //errorMessage = "로그인 실패: \(error.localizedDescription)"
            //} else {
                //errorMessage = ""
                //isShowingMainView = true
            //}
        //}
    }
}

#Preview {
    LoginView()
}


