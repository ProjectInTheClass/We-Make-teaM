import SwiftUI

struct UploadMySubmissionView: View {
    var onSubmit: (Member) -> Void
    
    @State private var uploadedFiles: [String] = [] // 업로드된 파일 목록
    @State private var uploadedTexts: [String] = [] // 업로드된 텍스트 목록
    @State private var isSubmitted = false // 제출 완료 상태
    @State private var showDummyFilePicker = false // 더미 파일 선택
    @State private var showTextInput = false // 텍스트 입력창 표시
    @State private var newTextInput = "" // 새로운 텍스트 입력
    @State private var showAlert = false // 알림창 표시
    @State private var alertTitle = "" // 알림창 제목
    @State private var alertMessage = "" // 알림창 메시지
    
    // 더미 파일 데이터
    private let dummyFiles = [
        URL(fileURLWithPath: "/Users/user/Documents/DummyFile1.pdf"),
        URL(fileURLWithPath: "/Users/user/Documents/DummyFile2.docx"),
        URL(fileURLWithPath: "/Users/user/Documents/DummyFile3.xlsx")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("과제 제출")
                .font(.title)
                .fontWeight(.semibold)
                .fontDesign(.rounded)
                .padding(.top)
                .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(alignment: .leading) {
                Button(action: {
                    if !isSubmitted {
                        showDummyFilePicker = true
                    }
                }) {
                    Label("+ 파일 추가", systemImage: "paperclip")
                        .foregroundColor(isSubmitted ? .gray : .black)
                        .font(.body)
                        .padding()
                        .frame(height: 45)
                        .background(isSubmitted ? Color.gray.opacity(0.2) : Color.white)
                        .cornerRadius(12)
                        .shadow(color: .gray, radius: 4, x: 0, y: 2)
                }
                .disabled(isSubmitted)
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
                
                // 업로드된 파일 목록
                if !uploadedFiles.isEmpty  {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("업로드된 파일:")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.top, 10)
                        
                        ForEach(uploadedFiles, id: \.self) { fileName in
                            HStack {
                                Image(systemName: "doc.fill")
                                    .foregroundColor(.yellow)
                                Text(fileName)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            VStack(alignment: .leading) {
                Divider()
                    .padding(.bottom, 10)
                
                // 텍스트 추가 버튼
                Button(action: {
                    if !isSubmitted {
                        showTextInput = true
                    }
                }) {
                    Label("+ 텍스트 추가", systemImage: "text.badge.plus")
                        .foregroundColor(isSubmitted ? .gray : .black)
                        .font(.body)
                        .padding()
                        .frame(height: 45)
                        .background(isSubmitted ? Color.gray.opacity(0.2) : Color.white)
                        .cornerRadius(12)
                        .shadow(color: .gray, radius: 4, x: 0, y: 2)
                }
                .disabled(isSubmitted) // 제출 완료 시 비활성화
                .sheet(isPresented: $showTextInput) {
                    VStack(spacing: 20) {
                        Text("텍스트 입력")
                            .font(.headline)
                        
                        TextField("URL 또는 내용을 입력하세요", text: $newTextInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
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
                
                // 업로드된 텍스트 목록
                if !uploadedTexts.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("업로드된 텍스트:")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.top, 10)
                        
                        ForEach(uploadedTexts, id: \.self) { text in
                            HStack {
                                Image(systemName: "text.bubble.fill")
                                    .foregroundColor(.yellow)
                                Text(text)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
                            .padding(.vertical, 5)
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
                        onSubmit(Member(name: "김현경", hasSubmitted: true, submittedFiles: uploadedFiles, submittedTexts: uploadedTexts))
                        isSubmitted = true
                        alertTitle = "제출 완료"
                        alertMessage = "파일 및 텍스트가 성공적으로 제출되었습니다."
                        showAlert = true
                    }
                }
            }) {
                Text(isSubmitted ? "다시 제출하기" : "제출하기")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background((uploadedFiles.isEmpty && uploadedTexts.isEmpty) ? Color.gray : Color.yellow)
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
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
        .navigationTitle("과제 제출")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    // Preview에서 사용할 Member 객체 생성
    UploadMySubmissionView(onSubmit: { updatedMember in
        // 제출된 데이터를 콘솔에 출력하거나, 실제로 어떻게 처리할지 결정
        print("제출 완료! 멤버: \(updatedMember.name)")
        print("제출된 파일: \(updatedMember.submittedFiles)")
        print("제출된 텍스트: \(updatedMember.submittedTexts)")
    })
}

