import SwiftUI

struct MemberSubmissionDetailView: View {
    var member: Member
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var comments: [Comment] = [
        Comment(author: "정광석", content: "좋은 제출물이네요!"),
        Comment(author: "신준용", content: "잘 참고하겠습니다.")
    ]
    @State private var newComment = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("\(member.name)의 제출물")
                .font(.largeTitle)
                .padding(.bottom)
                .frame(maxWidth: .infinity)

            // Submitted files
            Text("제출한 파일 1")
                .padding(.bottom)
                .frame(maxWidth: .infinity)
            Text("제출한 파일 2")
                .padding(.bottom)
                .frame(maxWidth: .infinity)
            Text("제출한 파일 3")
                .padding(.bottom)
                .frame(maxWidth: .infinity)
            
            Divider()
                .padding(.vertical, 20)

            // Comments Section
            Text("댓글")
                .font(.headline)
            
            ForEach(comments) { comment in
                HStack(alignment: .top, spacing: 15) {
                    VStack {
                        Image(systemName: "person.circle.fill") // Placeholder profile image
                            .resizable()
                            .frame(width: 40, height: 40)
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
            }

            // Add new comment section
            HStack {
                TextField("댓글을 입력하세요", text: $newComment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    if !newComment.isEmpty {
                        comments.append(Comment(author: "나", content: newComment))
                        newComment = ""
                    }
                }) {
                    Text("댓글 남기기")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding(.vertical)

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
                    .foregroundColor(.blue)
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
    MemberSubmissionDetailView(member: Member(name: "A", hasSubmitted: true))
}



