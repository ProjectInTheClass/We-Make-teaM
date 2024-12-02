import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PhotosUI

struct UserInfoSettingsView: View {
    @State private var nickname: String = ""
    @State private var email: String = ""
    @State private var profileImage: UIImage? = nil
    @State private var isLoading = true
    @State private var errorMessage = ""
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isShowingImagePicker = false // 이미지 선택 Sheet 표시
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if isLoading {
                    ProgressView()
                        .padding()
                } else {
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        VStack(spacing: 20) {
                            // 프로필 섹션
                            VStack {
                                if let profileImage = profileImage {
                                    Image(uiImage: profileImage)
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                                } else {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.blue)
                                }
                                Button("프로필 사진 변경") {
                                    isShowingImagePicker = true
                                }
                                .sheet(isPresented: $isShowingImagePicker) {
                                    ImagePicker(image: $profileImage, onImagePicked: uploadProfileImage)
                                }
                            }

                            // 닉네임 섹션
                            TextField("닉네임 수정", text: $nickname)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()

                            Button(action: updateNickname) {
                                Text("닉네임 저장")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }
                            .padding(.horizontal)

                            // 이메일 변경 섹션
                            TextField("새 이메일 입력", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()

                            Button(action: updateEmail) {
                                Text("이메일 변경")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.green)
                                    .cornerRadius(8)
                            }
                            .padding(.horizontal)

                            // 비밀번호 변경 섹션
                            SecureField("새 비밀번호", text: $newPassword)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()

                            SecureField("새 비밀번호 확인", text: $confirmPassword)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()

                            Button(action: updatePassword) {
                                Text("비밀번호 변경")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.red)
                                    .cornerRadius(8)
                            }
                            .padding(.horizontal)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("사용자 정보 관리")
            .onAppear(perform: loadUserData)
            .alert(alertTitle, isPresented: $showAlert) {
                Button("확인", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
    }

    // 사용자 데이터 로드
    func loadUserData() {
        guard let user = Auth.auth().currentUser else {
            errorMessage = "사용자 정보를 불러올 수 없습니다."
            isLoading = false
            return
        }

        email = user.email ?? ""

        let db = Firestore.firestore()
        db.collection("users").document(user.uid).getDocument { document, error in
            if let error = error {
                errorMessage = "데이터 불러오기 실패: \(error.localizedDescription)"
            } else if let data = document?.data() {
                nickname = data["nickname"] as? String ?? "닉네임 없음"
                if let photoURL = data["photoURL"] as? String {
                    loadProfileImage(from: photoURL)
                }
            }
            isLoading = false
        }
    }

    // 닉네임 저장
    func updateNickname() {
        guard let user = Auth.auth().currentUser else {
            errorMessage = "사용자 정보를 찾을 수 없습니다."
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(user.uid).updateData(["nickname": nickname]) { error in
            if let error = error {
                alertTitle = "닉네임 저장 실패"
                alertMessage = error.localizedDescription
            } else {
                alertTitle = "닉네임 저장 완료"
                alertMessage = "닉네임이 성공적으로 저장되었습니다."
            }
            showAlert = true
        }
    }

    // 이메일 변경
    func updateEmail() {
        guard let user = Auth.auth().currentUser else {
            errorMessage = "사용자 정보를 찾을 수 없습니다."
            return
        }

        user.updateEmail(to: email) { error in
            if let error = error {
                alertTitle = "이메일 변경 실패"
                alertMessage = error.localizedDescription
            } else {
                alertTitle = "이메일 변경 완료"
                alertMessage = "이메일이 성공적으로 변경되었습니다."
            }
            showAlert = true
        }
    }

    // 비밀번호 변경
    func updatePassword() {
        guard newPassword == confirmPassword else {
            alertTitle = "비밀번호 변경 실패"
            alertMessage = "새 비밀번호가 일치하지 않습니다."
            showAlert = true
            return
        }

        guard let user = Auth.auth().currentUser else {
            errorMessage = "사용자 정보를 찾을 수 없습니다."
            return
        }

        user.updatePassword(to: newPassword) { error in
            if let error = error {
                alertTitle = "비밀번호 변경 실패"
                alertMessage = error.localizedDescription
            } else {
                alertTitle = "비밀번호 변경 완료"
                alertMessage = "비밀번호가 성공적으로 변경되었습니다."
            }
            showAlert = true
        }
    }

    // 프로필 사진 업로드 및 URL 저장
    func uploadProfileImage(image: UIImage) {
        guard let user = Auth.auth().currentUser, let imageData = image.jpegData(compressionQuality: 0.8) else {
            errorMessage = "이미지 업로드 실패"
            return
        }

        let storageRef = Storage.storage().reference().child("profileImages/\(user.uid).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                alertTitle = "프로필 사진 저장 실패"
                alertMessage = error.localizedDescription
                showAlert = true
                return
            }

            storageRef.downloadURL { url, error in
                if let error = error {
                    alertTitle = "URL 가져오기 실패"
                    alertMessage = error.localizedDescription
                    showAlert = true
                    return
                }

                if let url = url {
                    saveProfileImageURL(url: url.absoluteString)
                }
            }
        }
    }

    // Firestore에 프로필 사진 URL 저장
    func saveProfileImageURL(url: String) {
        guard let user = Auth.auth().currentUser else {
            errorMessage = "사용자 정보를 찾을 수 없습니다."
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(user.uid).updateData(["photoURL": url]) { error in
            if let error = error {
                alertTitle = "프로필 사진 URL 저장 실패"
                alertMessage = error.localizedDescription
            } else {
                alertTitle = "프로필 사진 저장 완료"
                alertMessage = "프로필 사진이 성공적으로 저장되었습니다."
            }
            showAlert = true
        }
    }

    // Storage에서 프로필 이미지 로드
    func loadProfileImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.profileImage = image
                }
            }
        }.resume()
    }
}

// ImagePicker를 위한 구조체
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var onImagePicked: (UIImage) -> Void

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self, onImagePicked: onImagePicked)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        let onImagePicked: (UIImage) -> Void

        init(_ parent: ImagePicker, onImagePicked: @escaping (UIImage) -> Void) {
            self.parent = parent
            self.onImagePicked = onImagePicked
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
            provider.loadObject(ofClass: UIImage.self) { object, _ in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self.parent.image = image
                        self.onImagePicked(image)
                    }
                }
            }
        }
    }
}
