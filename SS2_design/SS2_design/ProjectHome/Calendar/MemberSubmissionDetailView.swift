import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct MemberSubmissionDetailView: View {
    var member: Member
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var comments: [Comment] = []
    @State private var newComment = ""
    
    // Firestore에서 해당 submission을 가져오기 위한 변수
    @State private var submittedFiles: [String] = []
    @State private var submittedTexts: [String] = []

    // Firestore에서 제출 데이터를 가져오는 함수
    func fetchSubmissionDetails() {
        let db = Firestore.firestore()

        // submissionId를 통해 Firestore에서 제출 정보를 가져옴
        db.collection("Submission")
            .document(member.submissionId) // 제출 ID로 필터링
            .getDocument { snapshot, error in
                if let error = error {
                    print("Error fetching submission details: \(error.localizedDescription)")
                    return
                }

                if let data = snapshot?.data() {
                    // 제출된 파일 및 텍스트 정보 가져오기
                    self.submittedFiles = data["fileName"] as? [String] ?? []
                    self.submittedTexts = data["URL"] as? [String] ?? []
                }
            }
    }

    // 댓글을 Firestore에 추가하는 메서드
    func addComment(content: String) {
        let db = Firestore.firestore()

        // 현재 사용자 정보와 댓글 내용
        let currentUser = Auth.auth().currentUser?.uid // 실제로는 현재 사용자의 ID를 가져와야 합니다.
        
        // Firestore에 댓글 추가
        db.collection("Submission")
            .document(member.submissionId)
            .collection("Comments")
            .addDocument(data: [
                "author": currentUser,
                "content": content,
                "timestamp": Timestamp(date: Date()) // 댓글 작성 시간 추가
            ]) { error in
                if let error = error {
                    print("Error adding comment: \(error.localizedDescription)")
                } else {
                    // 댓글 추가 성공 시, 댓글 리스트를 갱신하기 위해 fetch할 수도 있습니다.
                    print("Comment added successfully")
                    self.fetchComments() // 댓글 목록을 갱신하는 함수 호출
                }
            }
    }

    // 댓글을 가져오는 함수
    func fetchComments() {
        let db = Firestore.firestore()

        // 기존에 작성된 댓글을 가져옴
        db.collection("Submission")
            .document(member.submissionId)
            .collection("Comments")
            .order(by: "timestamp") // 시간 순으로 정렬
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching comments: \(error.localizedDescription)")
                    return
                }

                self.comments = []
                
                // 댓글 데이터를 가져오고, 각 댓글의 작성자 정보(닉네임)를 조회
                for document in snapshot?.documents ?? [] {
                    let data = document.data()
                    let authorID = data["author"] as? String ?? "Unknown"
                    let content = data["content"] as? String ?? ""
                    
                    // Firestore에서 사용자 정보를 가져와 nickname을 조회
                    db.collection("users").document(authorID).getDocument { userSnapshot, userError in
                        if let userError = userError {
                            print("Error fetching user details: \(userError.localizedDescription)")
                        } else if let userData = userSnapshot?.data() {
                            let nickname = userData["nickname"] as? String ?? "Unknown"
                            let comment = Comment(id: document.documentID, author: nickname, content: content)
                            self.comments.append(comment)
                        }
                    }
                }
            }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("\(member.name)의 제출물")
                .font(.largeTitle)
                .padding(.bottom)
                .frame(maxWidth: .infinity)
            
            if !submittedFiles.isEmpty {
                Text("Submitted Files:")
                    .font(.title3)
                    .foregroundColor(Color.yellow)
                    .font(.headline)
                    .padding(.bottom, 5)
                            
                ForEach(submittedFiles, id: \.self) { file in
                    Button(action: {
                        // 다운로드 로직을 추가해야 합니다.
                        print("다운로드: \(file)")
                    }) {
                        Text(file)
                            .foregroundColor(.blue) // 링크처럼 보이게
                            .padding(.bottom, 5)
                            .frame(maxWidth: .infinity)
                    }
                }
            } else {
                Text("제출된 파일이 없습니다.")
                    .foregroundColor(.gray)
                    .padding(.bottom, 5)
            }
            
            if !submittedTexts.isEmpty {
                Text("Submitted Text:")
                    .font(.title3)
                    .foregroundColor(Color.yellow)
                    .font(.headline)
                    .padding(.bottom, 5)
                    
                ForEach(submittedTexts, id: \.self) { text in
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
                            .frame(maxWidth: .infinity)
                    }
                }
            } else {
                Text("제출된 텍스트가 없습니다.")
                    .foregroundColor(.gray)
                    .padding(.bottom, 5)
            }

            
            Divider()
                .padding(.vertical, 20)
            
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
                                    .frame(width: 30, height: 30)
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
            
            Spacer()
            
            // Add new comment section
            HStack {
                TextField("댓글을 입력하세요", text: $newComment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    if !newComment.isEmpty {
                        addComment(content: newComment) // 댓글 추가 메서드 호출
                        newComment = ""
                    }
                }) {
                    Text("댓글 남기기")
                        .foregroundColor(.white)
                        .padding(8)
                        .border(Color.gray.opacity(0.8))
                        .background(Color.yellow.opacity(0.8))
                        .cornerRadius(3)
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
                    .foregroundColor(.black)
            }
            
            NavigationLink(destination: SettingView()) {
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.black)
            }
        })
        .onAppear {
            fetchSubmissionDetails() // 화면이 나타날 때 제출 정보를 불러옴
            fetchComments() // 화면이 나타날 때 댓글 목록을 불러옴
        }
    }
}

// Supporting structs
struct Comment: Identifiable {
    let id: String
    let author: String
    let content: String
}

#Preview {
    // Example Member with submissionId
    MemberSubmissionDetailView(member: Member(name: "김현경", hasSubmitted: true, submissionId: "submissionId123"))
}
