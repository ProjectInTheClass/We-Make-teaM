//
//  SubmittedView.swift
import SwiftUI

struct SubmittedView: View {
    var teamMembers: [TeamMember]
    @State private var comments: [String: [String]] = [:] // 팀원별 댓글 저장
    @State private var newComment: String = "" // 새 댓글 입력
    @State private var selectedMember: TeamMember? // 선택된 팀원
    
    var body: some View {
        VStack(spacing: 20) {
            Text("제출물 열람")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 30)
            
            // 팀원 목록
            List(teamMembers, id: \.id) { member in
                HStack {
                    member.profileImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        Text(member.name)
                            .font(.headline)
                        Button(action: {
                            selectedMember = member // 선택된 팀원 설정
                        }) {
                            Text("열람하기")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            
            Spacer()
            
            // 선택된 팀원이 있을 때 댓글 입력 및 목록 표시
            if let member = selectedMember {
                VStack(alignment: .leading) {
                    Text("\(member.name)의 댓글")
                        .font(.title2)
                        .padding(.top, 20)
                    
                    // 댓글 목록
                    ForEach(comments[member.name] ?? [], id: \.self) { comment in
                        Text("• \(comment)")
                            .padding(.vertical, 2)
                    }
                    
                    // 댓글 입력 필드
                    HStack {
                        TextField("댓글 입력...", text: $newComment)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: {
                            if !newComment.isEmpty {
                                comments[member.name, default: []].append(newComment)
                                newComment = ""
                            }
                        }) {
                            Text("추가")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                }
                .padding()
            }
        }
        .navigationTitle("제출물 열람")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SubmittedView(teamMembers: [
        TeamMember(name: "Alice", score: 90, profileImage: Image(systemName: "person.fill")),
        TeamMember(name: "Bob", score: 85, profileImage: Image(systemName: "person.fill")),
        TeamMember(name: "Charlie", score: 95, profileImage: Image(systemName: "person.fill")),
        TeamMember(name: "Dave", score: 80, profileImage: Image(systemName: "person.fill")),
        TeamMember(name: "Eve", score: 88, profileImage: Image(systemName: "person.fill"))
    ])
}
