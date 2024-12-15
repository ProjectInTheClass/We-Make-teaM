import SwiftUI

struct MemberSubmissionDetailView: View {
    var member: Member
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var comments: [Comment] = [
        Comment(author: "정광석", content: "코드 실행해보니 에러가 뜨는것같아요."),
        Comment(author: "신준용", content: "잘 참고하겠습니다.")
    ]
    @State private var newComment = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("\(member.name)의 제출물")
                .font(.largeTitle)
                .padding(.bottom)
                .frame(maxWidth: .infinity)
            
            if !member.submittedFiles.isEmpty {
                Text("제출된 파일:")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.yellow.opacity(0.8))
                    .font(.headline)
                    .padding(.bottom, 5)
                    .padding(.horizontal,10)
                            
                ForEach(member.submittedFiles, id: \.self) { file in
                    Button(action: {
                        // 다운로드 로직을 추가해야 합니다.
                        // 예: 파일 URL을 받아서 다운로드 처리
                        print("다운로드: \(file)")
                    }) {
                        Text(file)
                            .foregroundColor(.blue) // 링크처럼 보이게
                            .padding(.bottom, 5)
                            .padding(.leading, 20)
                            .padding(.horizontal,10)
                            //.frame(maxWidth: .infinity)
                    }
                }
            } else {
                Text("제출된 파일이 없습니다.")
                    .foregroundColor(.gray)
                    .padding(.bottom, 5)
                    .padding(.horizontal,10)
            }
            
            if !member.submittedTexts.isEmpty {
                Text("제출된 텍스트:")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.yellow.opacity(0.8))
                    .font(.headline)
                    .padding(.top, 10)
                    .padding(.bottom, 5)
                    .padding(.horizontal,10)
                    
                ForEach(member.submittedTexts, id: \.self) { text in
                    Button(action: {
                        // URL로 이동
                        if let url = URL(string: text) {
                            UIApplication.shared.open(url)
                        } else {
                            // 텍스트 복사
                            UIPasteboard.general.string = text
                        }
                    }) {
                        Text(text)
                            .foregroundColor(.blue) // 링크처럼 보이게
                            .padding(.bottom, 5)
                            .padding(.leading, 20)
                            .padding(.horizontal,10)
                            //.frame(maxWidth: .infinity)
                    }
                }
            } else {
                Text("제출된 텍스트가 없습니다.")
                    .foregroundColor(.gray)
                    .padding(.bottom, 5)
            }

            Divider()
                .frame(height: 0.4) // 굵기 설정
                .background(Color.gray) // 색상 설정


            
            ScrollView{
                VStack(alignment: .leading){
                    // Comments Section
                    Text("댓글")
                        .font(.headline)
                    
                    
                    ForEach(comments) { comment in
                        HStack(alignment: .top, spacing: 15) {
                            VStack {
                                Image(systemName: "person.circle.fill") // Placeholder profile image
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(.gray)
                                Text(comment.author)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                            }
                            Text(comment.content)
                                .font(.body)
                                .padding(15)
                        }
                        .padding(.vertical, 10)
                        Divider()
                    }
                }
            }
            .padding(.horizontal,10)

            Spacer()
            // Add new comment section
            HStack {
                TextField("Add comment...", text: $newComment)
                    .padding(.horizontal, 15)
                    .frame(height: 40)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)

                Button(action: {
                    if !newComment.isEmpty {
                        // 댓글 추가 로직
                        print("댓글 작성: \(newComment)")
                        newComment = ""
                    }
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.yellow.opacity(0.8))
                }
                .padding(.trailing, 10)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.white)


            Spacer()
        }
        .padding()
        .navigationTitle("\(member.name) 제출물")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: HStack {
            Button(action: {
                navigationManager.resetToRoot()
            }) {
                Text("WMM")
                    .font(.headline)
                    .foregroundColor(.black)
            }
            
            NavigationLink(destination: SettingView()) {
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.black)
            }
        })
    }
}

// Supporting structs
struct Comment: Identifiable {
    let id = UUID()
    let author: String
    let content: String
}

#Preview {
    // Example Member with submitted files and texts
    MemberSubmissionDetailView(member: Member(name: "김현경", hasSubmitted: true, submittedFiles: ["과제_파일1.pdf", "과제_파일2.pptx"], submittedTexts: ["https://github.com/We-Make-teaM"]))
}

