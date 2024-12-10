import SwiftUI
import FirebaseFirestore

struct ParticipationRankingView: View {
    var projectName: String
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var currentDate = Date()
    @State private var participants: [Participant] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 0) {
                    ZStack {
                        Text("Team Ranking")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.top, 10)
                    
                    HStack {
                        Text("\(formattedDate)")
                            .foregroundColor(.red)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                        
                        Text(" 까지의 참여도 순위")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .offset(x: -7)
                    }
                }
                
                VStack(spacing: 20) {
                    ForEach(Array(sortedParticipants.enumerated()), id: \.offset) { index, participant in
                        HStack {
                            Text(" \(index + 1) ")
                                .fontWeight(.bold)
                                .font(index == 0 ? .title : .title2) // 1등은 더 큰 글씨
                            Image("profile")
                                .resizable()
                                .frame(width: index == 0 ? 80 : 70, height: index == 0 ? 70 : 60) // 1등은 더 큰 이미지
                                .foregroundColor(.black)
                                .background(Color.white)
                            Spacer()
                            Text("\(participant.name): ")
                                .fontWeight(.bold)
                                .font(index == 0 ? .title : .title2) // 1등은 더 큰 글씨
                            Spacer()
                            Spacer()
                            Text("\(participant.score)점")
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .font(index == 0 ? .title2 : .headline) // 1등은 더 큰 점수 글씨
                            Spacer()
                            Spacer()
                        }
                        .padding(index == 0 ? 15 : 10) // 1등은 더 넓은 여백
                        .frame(width: index == 0 ? 340 : 320, height: index == 0 ? 80 : 70) // 1등은 더 큰 프레임
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.15), radius: 6, x: 4, y: 4)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(index == 0 ? Color.yellow.opacity(0.5) : Color.gray.opacity(0.5), lineWidth: index == 0 ? 3 : 1) // 1등은 노란색 테두리
                        )
                    }
                }
                .padding(.top, 20)

            }
            .padding()
            .navigationTitle("참여도 순위")
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
        .onAppear {
            fetchParticipantsScore(for: projectName)
        }
    }
    
    // 현재 날짜 형식 설정
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: currentDate)
    }
    
    // 점수 기준으로 내림차순 정렬된 참여자 리스트
    private var sortedParticipants: [Participant] {
        participants.sorted { $0.score > $1.score }
    }
    
    // 프로젝트 참여자의 점수 데이터를 가져오는 함수
    func fetchParticipantsScore(for projectName: String) {
        let db = Firestore.firestore()
        
        // 프로젝트 이름으로 이벤트 가져오기
        db.collection("events")
            .whereField("projectName", isEqualTo: projectName)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching events: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No events found.")
                    return
                }
                
                var participants: [Participant] = []
                
                // 각 이벤트에 대해 멤버를 가져오고 점수를 계산
                for document in documents {
                    let data = document.data()
                    
                    // 해당 이벤트의 참여자 리스트 가져오기
                    if let participantsList = data["participants"] as? [String] {
                        // 참여자 리스트에서 각 멤버의 점수를 가져옴
                        print(participantsList)
                        for participantId in participantsList {
                            // 해당 멤버의 점수를 Firestore에서 가져옴
                            db.collection("users").document(participantId).getDocument { userSnapshot, error in
                                if let error = error {
                                    print("Error fetching user data: \(error.localizedDescription)")
                                } else if let userData = userSnapshot?.data() {
                                    if let nickname = userData["nickname"] as? String {
                                        // 멤버의 점수 가져오기
                                        db.collection("Submission")
                                            .whereField("eventId", isEqualTo: document.documentID)
                                            .whereField("memberId", isEqualTo: participantId)
                                            .getDocuments { submissionSnapshot, error in
                                                if let error = error {
                                                    print("Error fetching submission data: \(error.localizedDescription)")
                                                } else if let submissionDocuments = submissionSnapshot?.documents, let submissionDoc = submissionDocuments.first {
                                                    // 점수 계산, 예시로 100점에서 제출 상태에 따라 점수 차감
                                                    let score = submissionDoc["isSubmitted"] as? Bool ?? false ? 100 : 0
                                                    
                                                    // 점수와 이름을 Participant 배열에 추가
                                                    let participant = Participant(name: nickname, score: score)
                                                    participants.append(participant)
                                                }
                                            }
                                    }
                                }
                            }
                        }
                    }
                }
                
                // 참여자 데이터 업데이트 (UI 갱신을 위해 메인 쓰레드에서 실행)
                DispatchQueue.main.async {
                    self.participants = participants
                }
                print(participants)
            }
    }
}

struct Participant {
    let name: String
    let score: Int
}

#Preview {
    ParticipationRankingView(projectName: "소프트웨어 스튜디오 2")
}
