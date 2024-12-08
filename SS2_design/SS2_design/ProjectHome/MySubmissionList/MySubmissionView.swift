import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct TeamMember: Identifiable {
    let id = UUID()
    let name: String
    let score: Int
    let profileImage: Image
}

struct Submission: Identifiable {
    let id = UUID()
    let title: String
    let deadline: Date
    let priority: Int
    let isSubmitted: Bool
    let fileName: String
    let fileSize: String
}

struct MySubmissionView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var navigateToRoot = false
    @Environment(\.presentationMode) var presentationMode
    var projectName: String
    var teamMembers: [TeamMember]
    
    @State private var submissions: [Submission] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var unfinishedSubmissions: [Submission] {
        submissions.filter { !$0.isSubmitted }.sorted { $0.deadline < $1.deadline }
    }

    var finishedSubmissions: [Submission] {
        submissions.filter { $0.isSubmitted }.sorted { $0.deadline > $1.deadline }
    }

    var currentUserId: String {
        return Auth.auth().currentUser?.uid ?? ""
    }

    func loadSubmissions() {
        let db = Firestore.firestore()
        let submissionsRef = db.collection("Submission")
        
        isLoading = true
        submissionsRef.whereField("memberId", isEqualTo: currentUserId)
            .getDocuments { snapshot, error in
                if let error = error {
                    self.errorMessage = "데이터를 불러오는 중 오류가 발생했습니다: \(error.localizedDescription)"
                    self.isLoading = false
                    return
                }
                print(currentUserId)

                self.submissions = snapshot?.documents.compactMap { doc -> Submission? in
                    let data = doc.data()
                    guard let title = data["title"] as? String,
                          let deadlineTimestamp = data["deadline"] as? Timestamp,
                          let priority = data["priority"] as? Int,
                          let isSubmitted = data["isSubmitted"] as? Bool,
                          let fileName = data["fileName"] as? String,
                          let fileSize = data["fileSize"] as? String else {
                        return nil
                    }

                    let deadline = deadlineTimestamp.dateValue()
                    return Submission(title: title, deadline: deadline, priority: priority, isSubmitted: isSubmitted, fileName: fileName, fileSize: fileSize)
                } ?? []
                self.isLoading = false
            }
        print(submissions)
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("My Submission View")
                .font(.system(size: 38, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity)
                .padding()

            if isLoading {
                ProgressView("데이터를 불러오는 중...")
                    .progressViewStyle(CircularProgressViewStyle())
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                ScrollView {
                    Divider()
                        .overlay(
                            Text("제출 미완료")
                                .font(.headline)
                                .padding()
                                .background(Color.white)
                        )
                    ForEach(unfinishedSubmissions) { submission in
                        NavigationLink(destination: SubmissionDetailView(submission: submission, teamMembers: teamMembers)) {
                            VStack(alignment: .leading) {
                                Text(submission.title)
                                    .font(.headline)
                                Text("마감일: \(submission.deadline, style: .date)")
                                    .font(.subheadline)
                            }
                            .padding()
                            .background(getDeadlineColor(for: submission))
                            .cornerRadius(10)
                        }
                    }

                    Divider()
                        .overlay(
                            Text("제출 완료")
                                .font(.headline)
                                .padding()
                                .background(Color.white)
                        )
                    ForEach(finishedSubmissions) { submission in
                        NavigationLink(destination: SubmissionDetailView(submission: submission, teamMembers: teamMembers)) {
                            VStack(alignment: .leading) {
                                Text(submission.title)
                                    .font(.headline)
                                Text("마감일: \(submission.deadline, style: .date)")
                                    .font(.subheadline)
                            }
                            .padding()
                            .background(Color.yellow.opacity(0.4))
                            .cornerRadius(10)
                        }
                    }
                }
            }
        }
        .onAppear {
            loadSubmissions()
        }
    }


    // 마감일까지 남은 일자에 따라 색상 결정
    func getDeadlineColor(for submission: Submission) -> Color {
        let timeInterval = submission.deadline.timeIntervalSince(Date())
        let daysLeft = timeInterval / (60 * 60 * 24) // 남은 일수

        switch daysLeft {
        case _ where daysLeft < 1:
            return Color.red.opacity(0.9) // 마감일이 하루 이내
        case 1..<3:
            return Color.red.opacity(0.6) // 1-2일 남음
        default:
            return Color.red.opacity(0.3) // 3일 이상
        }
    }
}

struct SubmissionDetailView: View {
    let submission: Submission
    var teamMembers : [TeamMember]
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(submission.title)
                .font(.title)
                .padding(.top)
            
            Text("마감일: \(submission.deadline, style: .date)")
                .font(.subheadline)
            
            Text("파일 이름: \(submission.fileName)")
            Text("파일 크기: \(submission.fileSize)")
            Text("중요도: \(submission.priority)")
            
            Spacer()
            
            // "제출물 확인" 버튼
            NavigationLink(destination: SubmittedView(teamMembers: teamMembers)) {
                Text("제출물 확인")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .padding()
        .navigationTitle("제출물 세부 정보")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MySubmissionView(projectName: "소프트웨어스튜디오2", teamMembers: [
        TeamMember(name: "Alice", score: 90, profileImage: Image(systemName: "person.fill")),
        TeamMember(name: "Bob", score: 85, profileImage: Image(systemName: "person.fill")),
        TeamMember(name: "Charlie", score: 95, profileImage: Image(systemName: "person.fill")),
        TeamMember(name: "Dave", score: 80, profileImage: Image(systemName: "person.fill")),
        TeamMember(name: "Eve", score: 88, profileImage: Image(systemName: "person.fill"))
    ])
}
