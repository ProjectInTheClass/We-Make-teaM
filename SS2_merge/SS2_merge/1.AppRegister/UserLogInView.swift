import SwiftUI
//import FirebaseAuth

struct LogInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @State private var isShowingMainView = false
    @State private var isLoading = false // 로딩 상태 추가
    @State private var showPassword = false // 비밀번호 보이기/숨기기

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
                
                    Text("서비스 이용을 위해 로그인 해주세요")
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
                    ZStack {
                        if showPassword {
                            TextField("비밀번호", text: $password)
                                .padding()
                                .frame(height: 50) // 높이 조정
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(color: Color.gray.opacity(0.3), radius: 3, x: 0, y: 2)
                                .padding(.horizontal)

                        } else {
                            SecureField("비밀번호", text: $password)
                                .padding()
                                .frame(height: 50) // 높이 조정
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(color: Color.gray.opacity(0.3), radius: 3, x: 0, y: 2)
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
                }
                
                VStack(spacing: 10){
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
                                .background(Color.yellow.opacity(0.8))
                                .cornerRadius(8)
                        }
                    }
                    //.padding(.horizontal)
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
            .padding(.horizontal,15)
            
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
    LogInView()
}

