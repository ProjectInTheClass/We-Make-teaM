import  SwiftUI
//import FirebaseAuth

struct RegisterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String = ""
    @State private var isLoading = false
    @Environment(\.dismiss) var dismiss // 회원가입 후 로그인 화면으로 돌아가기

    var body: some View {
        ZStack{
            Color.yellow
                .opacity(0.1)
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: 60) {
                Spacer()
                VStack(spacing:0){
                    // 앱 로고
                    Image("WMM")
                        .resizable()
                        .frame(width: 260, height: 120)
                
                    Text("회원가입을 완료해주세요")
                        .font(.system(size: 15, weight: .regular, design: .rounded))
                        .padding(.top, 10)
            
                }
                
                VStack(spacing: 25){
                    // 이메일 입력
                    TextField("이메일", text: $email)
                        .padding()
                        .frame(height: 50) // 높이 조정
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: Color.gray.opacity(0.3), radius: 3, x: 0, y: 2)
                        .padding(.horizontal)
                    
                    // 비밀번호 입력
                    SecureField("비밀번호", text: $password)
                        .padding()
                        .frame(height: 50) // 높이 조정
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: Color.gray.opacity(0.3), radius: 3, x: 0, y: 2)
                        .padding(.horizontal)
                    
                    // 비밀번호 확인 입력
                    SecureField("비밀번호 확인", text: $confirmPassword)
                        .padding()
                        .frame(height: 50) // 높이 조정
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: Color.gray.opacity(0.3), radius: 3, x: 0, y: 2)
                        .padding(.horizontal)
                    
                    // 오류 메시지
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }
                    
                }

                VStack(spacing: 10){
                    // 가입하기 버튼
                    Button(action: register) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(8)
                        } else {
                            Text("가입하기")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.yellow.opacity(0.8))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                    .disabled(isLoading) // 로딩 중 버튼 비활성화
                    
                    Spacer()
                }
                Spacer()
                Spacer()
            }
            .padding()
            .padding(.horizontal,15)
            .navigationTitle("회원가입")
            .navigationBarTitleDisplayMode(.inline)
            
        }
        
    }

    func register() {
        // 유효성 검사
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
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
        //Auth.auth().createUser(withEmail: email, password: password) { result, error in
            //isLoading = false
            //if let error = error {
                //errorMessage = "회원가입 실패: \(error.localizedDescription)"
            //} else {
                //errorMessage = ""
                //dismiss() // 회원가입 성공 후 로그인 화면으로 돌아가기
            //}
        //}
    }
}

#Preview {
    RegisterView()
}
