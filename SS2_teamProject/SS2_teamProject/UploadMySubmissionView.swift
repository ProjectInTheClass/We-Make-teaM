//일정에 대한 제출물 올리기
import SwiftUI

struct UploadMySubmissionView: View {
    var onSubmit: () -> Void
    
    @State private var fileUploaded = false // Track file upload status
    @State private var isSubmitted = false // Track submission completion status
    
    var body: some View {
        VStack(spacing: 20) {
            Text("과제 제출")
                .font(.title)
            
            Button(action: {
                // Simulate file upload
                fileUploaded = true
                isSubmitted = false // Reset submission status if re-uploading
            }) {
                Text(fileUploaded ? "파일 업로드 완료" : "파일 업로드")
                    .foregroundColor(.blue)
            }
            .padding()
            .background(fileUploaded ? Color.gray.opacity(0.2) : Color.blue.opacity(0.2))
            .cornerRadius(8)
            
            Button(action: {
                if fileUploaded {
                    onSubmit()
                    isSubmitted = true
                }
            }) {
                Text(isSubmitted ? "제출 완료" : (fileUploaded ? "제출하기" : "재제출하기"))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(fileUploaded ? Color.green : Color.gray)
                    .cornerRadius(8)
                    .padding(.horizontal, 10)
            }
            .disabled(!fileUploaded)
        }
        .padding()
        .navigationTitle("과제 제출")
    }
}

#Preview {
    UploadMySubmissionView(onSubmit: {})
}

