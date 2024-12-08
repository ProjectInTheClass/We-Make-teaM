import SwiftUI
import UniformTypeIdentifiers
import FirebaseFirestore
import FirebaseAuth
struct UploadMySubmissionView: View {
    var onSubmit: () -> Void
    var event : String
    @State private var uploadedFiles: [String] = [] // 업로드된 파일 목록
    @State private var uploadedTexts: [String] = [] // 업로드된 텍스트 목록
    @State private var isSubmitted = false // 제출 완료 상태
    @State private var showDummyFilePicker = false // 더미 파일 선택
    @State private var showTextInput = false // 텍스트 입력창 표시
    @State private var newTextInput = "" // 새로운 텍스트 입력
    @State private var showAlert = false // 알림창 표시å
    @State private var alertTitle = "" // 알림창 제목
    @State private var alertMessage = "" // 알림창 메시지
    
    var currentUserId: String {
        return Auth.auth().currentUser?.uid ?? ""
    }
    
    
    func updateSubmissionStatus(eventId: String, memberId: String) {
            let db = Firestore.firestore()
            
            // Firestore에서 submission 문서를 검색
            db.collection("Submission")
                .whereField("eventId", isEqualTo: eventId)
                .whereField("memberId", isEqualTo: memberId)
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("Error fetching submission: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let documents = snapshot?.documents, !documents.isEmpty else {
                        print("No submission found for the given eventId and memberId.")
                        return
                    }
                    
                    // 문서를 업데이트
                    for document in documents {
                        db.collection("submission").document(document.documentID).updateData(["isSubmitted": true]) { error in
                            if let error = error {
                                print("Error updating submission: \(error.localizedDescription)")
                            } else {
                                print("Submission status updated successfully!")
                            }
                        }
                    }
                }
        }
    // 더미 파일 데이터
    private let dummyFiles = [
        URL(fileURLWithPath: "/Users/user/Documents/DummyFile1.pdf"),
        URL(fileURLWithPath: "/Users/user/Documents/DummyFile2.docx"),
        URL(fileURLWithPath: "/Users/user/Documents/DummyFile3.xlsx")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            Text("과제 제출")
                .font(.title)
                .fontWeight(.semibold)
                .fontDesign(.rounded)
                .padding()
                .frame(maxWidth: .infinity)
            
            VStack(alignment: .leading){
                // 파일 추가 버튼
                Button(action: {
                    if !isSubmitted { // 제출 완료 시 파일 추가 불가
                        showDummyFilePicker = true
                    }
                }) {
                    Text("+ 파일 추가")
                        .foregroundColor(isSubmitted ? .gray : .black)
                }
                .padding()
                .frame(height:45)
                .background(isSubmitted ? Color.gray.opacity(0.2) : Color.white.opacity(0.6))
                .border(!isSubmitted ? Color.yellow : Color.white)
                .cornerRadius(3)
                .disabled(isSubmitted) // 제출 완료 시 비활성화
                .actionSheet(isPresented: $showDummyFilePicker) {
                    ActionSheet(
                        title: Text("파일 선택"),
                        message: Text("파일을 선택해주세요"),
                        buttons: dummyFiles.map { file in
                            .default(Text(file.lastPathComponent)) {
                                if !uploadedFiles.contains(file.lastPathComponent) {
                                    uploadedFiles.append(file.lastPathComponent)
                                }
                            }
                        } + [.cancel()]
                    )
                }
                
                // 업로드된 파일 및 텍스트 목록
                if !uploadedFiles.isEmpty  {
                    VStack(alignment: .leading, spacing: 10) {
                        if !uploadedFiles.isEmpty {
                            Text("업로드된 파일:")
                                .padding(.top, 10)
                                .font(.headline)
                                .foregroundColor(.gray)
                            ForEach(uploadedFiles, id: \.self) { fileName in
                                Text("• \(fileName)")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
    
            }

            
            VStack(alignment: .leading){
                Divider()
                    .padding(.bottom,10)
                // 텍스트 추가 버튼
                Button(action: {
                    if !isSubmitted {
                        showTextInput = true
                    }
                }) {
                    Text("+ 텍스트 추가")
                        .foregroundColor(isSubmitted ? .gray : .black)
                }
                .padding()
                .frame(height:45)
                .background(isSubmitted ? Color.gray.opacity(0.2) : Color.white.opacity(0.6))
                .border(!isSubmitted ? Color.yellow : Color.white)
                .cornerRadius(3)
                .disabled(isSubmitted) // 제출 완료 시 비활성화
                .sheet(isPresented: $showTextInput) {
                    VStack(spacing: 20) {
                        Text("텍스트 입력")
                            .font(.headline)
                        TextField("URL 또는 내용을 입력하세요", text: $newTextInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        HStack {
                            Button(action: {
                                if !newTextInput.isEmpty {
                                    uploadedTexts.append(newTextInput)
                                    newTextInput = ""
                                    showTextInput = false
                                }
                            }) {
                                Text("추가")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.yellow)
                                    .cornerRadius(8)
                            }
                            
                            Button(action: {
                                newTextInput = ""
                                showTextInput = false
                            }) {
                                Text("취소")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.black)
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding()
                }
                
                // 업로드된 파일 및 텍스트 목록
                if !uploadedTexts.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        
                        if !uploadedTexts.isEmpty {
                            Text("업로드된 텍스트:")
                                .padding(.top, 10)
                                .font(.headline)
                                .foregroundColor(.gray)
                            ForEach(uploadedTexts, id: \.self) { text in
                                Text("• \(text)")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                
            }
            
            
            Divider()
            // 제출 버튼
            Button(action: {
                if !uploadedFiles.isEmpty || !uploadedTexts.isEmpty {
                    if isSubmitted {
                        // 다시 제출하기 처리
                        uploadedFiles.removeAll()
                        uploadedTexts.removeAll()
                        isSubmitted = false
                    } else {
                        // 제출 처리
                        onSubmit()
                        isSubmitted = true
                        alertTitle = "제출 완료"
                        alertMessage = "파일 및 텍스트가 성공적으로 제출되었습니다."
                        showAlert = true
                    }
                }
            }) {
                Text(isSubmitted ? "다시 제출하기" : "제출하기")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background((uploadedFiles.isEmpty && uploadedTexts.isEmpty) ? Color.gray : Color.yellow.opacity(0.7))
                    .cornerRadius(8)
                    .padding(.horizontal, 10)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("확인"))
                )
            }
            Spacer()
        }
        .padding()
        .navigationTitle("과제 제출")
    }
}

//#Preview {
//    UploadMySubmissionView(onSubmit: {
//        print("제출 완료!")
//    }, event : event)
//}
