import SwiftUI

struct UserInfoSettingsView: View {
    @State private var selectedTab: Tab = .profile
    @State private var nickname: String = ""
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    enum Tab: String, CaseIterable {
        case profile = "프로필 관리"
        case password = "비밀번호 변경"
    }
    
    var body: some View {
        VStack {
            // 상단 탭 전환
            Picker("설정", selection: $selectedTab) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(10)
            .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
            .padding([.horizontal, .top])
            
            // 선택된 탭에 따라 다른 뷰를 표시
            if selectedTab == .profile {
                ProfileSettingsView(nickname: $nickname)
            } else if selectedTab == .password {
                PasswordSettingsView(currentPassword: $currentPassword, newPassword: $newPassword, confirmPassword: $confirmPassword)
            }
            
            Spacer()
        }
        .navigationTitle("사용자 정보 관리")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("알림"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
        }
    }
}

// 프로필 관리 뷰
struct ProfileSettingsView: View {
    @Binding var nickname: String
    @State private var selectedImage: UIImage? = nil
    @State private var isShowingImagePicker = false
    @State private var showChangeButton: Bool = false
    @State private var showAlert = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            // 프로필 사진 표시
            Image(uiImage: selectedImage ?? UIImage(systemName: "person.circle.fill")!)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .shadow(radius: 5)
                .foregroundColor(selectedImage == nil ? .white : .clear)
                .onTapGesture {
                    withAnimation {
                        showChangeButton.toggle()
                    }
                }
            
            // "프로필 변경" 버튼 표시
            if showChangeButton {
                Button(action: {
                    isShowingImagePicker = true
                }) {
                    HStack {
                        Image(systemName: "photo.on.rectangle.angled")
                        Text("프로필 변경")
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                }
                .transition(.opacity)
                .sheet(isPresented: $isShowingImagePicker) {
                    ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
                        .onDisappear {
                            withAnimation {
                                showChangeButton = false
                            }
                        }
                }
            }
            
            TextField("닉네임 변경", text: $nickname)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
            
            Button(action: {
                if nickname.trimmingCharacters(in: .whitespaces).isEmpty {
                    // 닉네임이 비어 있을 경우
                    alertMessage = "닉네임을 입력해주세요."
                    showAlert = true
                } else {
                    print("닉네임 저장됨: \(nickname)")
                    // 저장 로직 추가
                    alertMessage = "닉네임이 성공적으로 저장되었습니다."
                    showAlert = true
                }
            }) {
                Text("변경사항 저장")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(nickname.trimmingCharacters(in: .whitespaces).isEmpty ? Color.gray : Color.yellow)
                    .cornerRadius(10)
                    .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
            }
            .disabled(nickname.trimmingCharacters(in: .whitespaces).isEmpty)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("알림"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
            }
        }
        .padding()
    }
}

// 비밀번호 변경 뷰
struct PasswordSettingsView: View {
    @Binding var currentPassword: String
    @Binding var newPassword: String
    @Binding var confirmPassword: String
    @State private var showPasswordMismatchAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: "lock.shield")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.yellow)
                Text("비밀번호 변경")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            
            SecureField("현재 비밀번호", text: $currentPassword)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
            
            SecureField("새 비밀번호", text: $newPassword)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
            
            SecureField("새 비밀번호 확인", text: $confirmPassword)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
            
            Button(action: {
                if newPassword == confirmPassword && !newPassword.isEmpty {
                    print("비밀번호 변경됨")
                    // 비밀번호 변경 로직 추가
                } else {
                    showPasswordMismatchAlert = true
                }
            }) {
                Text("변경하기")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background((newPassword == confirmPassword) && !newPassword.isEmpty ? Color.purple : Color.gray)
                    .cornerRadius(10)
                    .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
            }
            .disabled(!(newPassword == confirmPassword) || newPassword.isEmpty)
            .alert(isPresented: $showPasswordMismatchAlert) {
                Alert(title: Text("비밀번호 불일치"), message: Text("새 비밀번호가 일치하지 않습니다."), dismissButton: .default(Text("확인")))
            }
        }
        .padding()
    }
}

// ImagePicker 구현
struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        picker.allowsEditing = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

struct UserInfoSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserInfoSettingsView()
        }
    }
}
