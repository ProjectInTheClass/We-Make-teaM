//나의 전체 제출목록들 보기
import SwiftUI

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

// 예시 데이터

private var submissions: [Submission] = [
    Submission(title: "제출물 1", deadline: Calendar.current.date(byAdding: .day, value: 2, to: Date())!, priority: 3, isSubmitted: true, fileName: "project1.pdf", fileSize: "2MB"),
    Submission(title: "제출물 2", deadline: Calendar.current.date(byAdding: .day, value: 5, to: Date())!, priority: 2, isSubmitted: true, fileName: "report.docx", fileSize: "500KB"),
    Submission(title: "과제 1", deadline: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, priority: 1, isSubmitted: true, fileName: "assignment1.pdf", fileSize: "1.5MB"),
    Submission(title: "과제 2", deadline: Calendar.current.date(byAdding: .day, value: 10, to: Date())!, priority: 2, isSubmitted: false, fileName: "task.docx", fileSize: "750KB"),
    Submission(title: "프로젝트 발표", deadline: Calendar.current.date(byAdding: .day, value: 3, to: Date())!, priority: 1, isSubmitted: false, fileName: "presentation.pptx", fileSize: "4MB"),
    Submission(title: "과제 3", deadline: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, priority: 1, isSubmitted: false, fileName: "assignment2.pdf", fileSize: "2MB"),
    Submission(title: "최종 보고서", deadline: Calendar.current.date(byAdding: .day, value: 7, to: Date())!, priority: 2, isSubmitted: false, fileName: "final_report.pdf", fileSize: "1MB"),
    Submission(title: "퀴즈 1", deadline: Calendar.current.date(byAdding: .hour, value: 12, to: Date())!, priority: 1, isSubmitted: false, fileName: "quiz1.pdf", fileSize: "200KB")
]

struct MySubmissionView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var navigateToRoot = false
    @Environment(\.presentationMode) var presentationMode
    var projectName: String
    var teamMembers : [TeamMember]
    
    // 미완료와 완료 항목을 별도로 나누기
       var unfinishedSubmissions: [Submission] {
           submissions.filter { !$0.isSubmitted }.sorted { $0.deadline < $1.deadline }
       }
       
       var finishedSubmissions: [Submission] {
           submissions.filter { $0.isSubmitted }.sorted { $0.deadline > $1.deadline }
       }
    
    // 이미 제출한 항목이 위에 오고, 그 다음 마감일까지 남은 일자 기준으로 정렬
    var sortedSubmissions: [Submission] {
        submissions.sorted {
            if $0.isSubmitted != $1.isSubmitted {
                return !$0.isSubmitted && $1.isSubmitted // 미완료 항목이 위로
            }
            if $0.isSubmitted && $1.isSubmitted {
                return $0.deadline > $1.deadline // 완료 항목 중 오래된 항목이 아래로
            }
            return $0.deadline < $1.deadline // 미완료 항목은 마감일 순으로
        }
    }

    var body: some View {
        VStack(spacing: 20) {
                    Text("My Submission View")
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                    ScrollView {
                        // 미완료 과제
                        Divider()
                            .background(Color.gray.opacity(0.7))
                            .padding(.vertical, 15)
                            .padding(10)
                            .overlay(
                                Text("제출 미완료")
                                    .font(.headline)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(Color.white)
                            )
                            .frame(maxWidth: .infinity)
                        ForEach(unfinishedSubmissions) { submission in
                            NavigationLink(destination: SubmissionDetailView(submission: submission, teamMembers: teamMembers)) {
                                VStack(alignment: .leading) {
                                    
                                    HStack {
                                        Text(submission.title)
                                            .font(submission.priority == 1 ? .title3 : .headline)
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                        Text("중요도: \(submission.priority)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Text("마감일: \(submission.deadline, style: .date)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(getDeadlineColor(for: submission))
                                .cornerRadius(10)
                                .padding(.horizontal)
                            }
                        }
                        
                        // 구분선
                        if !unfinishedSubmissions.isEmpty && !finishedSubmissions.isEmpty {
                            Divider()
                                .background(Color.gray.opacity(0.7))
                                .padding(.vertical, 15)
                                .padding(10)
                                .overlay(
                                    Text("제출 완료")
                                        .font(.headline)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                        .background(Color.white)
                                )
                                .frame(maxWidth: .infinity)
                            
                        }
                        
                        // 완료 과제
                        ForEach(finishedSubmissions) { submission in
                            NavigationLink(destination: SubmissionDetailView(submission: submission, teamMembers: teamMembers)) {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(submission.title)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                        Text("중요도: \(submission.priority)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Text("마감일: \(submission.deadline, style: .date)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(Color.yellow.opacity(0.4))
                                .cornerRadius(10)
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .navigationTitle("나의 제출")
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
