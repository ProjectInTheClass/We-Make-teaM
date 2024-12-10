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
                            Text(" \(participant.rank) ")
                                .fontWeight(.bold)
                                .font(participant.rank == 1 ? .title : .title2) // 1등은 더 큰 글씨
                            Image("profile")
                                .resizable()
                                .frame(width: participant.rank == 1 ? 80 : 70, height: participant.rank == 1 ? 70 : 60) // 1등은 더 큰 이미지
                                .foregroundColor(.black)
                                .background(Color.white)
                            Spacer()
                            Text("\(participant.name): ")
                                .fontWeight(.bold)
                                .font(participant.rank == 1 ? .title : .title2) // 1등은 더 큰 글씨
                            Spacer()
                            Spacer()
                            Text("\(participant.score)점")
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .font(participant.rank == 1 ? .title2 : .headline) // 1등은 더 큰 점수 글씨
                            Spacer()
                            Spacer()
                        }
                        .padding(participant.rank == 1 ? 15 : 10) // 1등은 더 넓은 여백
                        .frame(width: participant.rank == 1 ? 340 : 320, height: participant.rank == 1 ? 80 : 70) // 1등은 더 큰 프레임
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.15), radius: 6, x: 4, y: 4)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(participant.rank == 1 ? Color.yellow.opacity(0.5) : Color.gray.opacity(0.5), lineWidth: participant.rank == 1 ? 3 : 1) // 1등은 노란색 테두리
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
    
    // 점수 기준으로 내림차순 정렬된 참여자 리스트와 순위 추가
    private var sortedParticipants: [Participant] {
        // 점수 기준으로 내림차순 정렬
        let sorted = participants.sorted { $0.score > $1.score }
        
        // 순위 부여
        var rank = 1
        var lastScore: Int?
        var result: [Participant] = []
        
        for participant in sorted {
            if let last = lastScore, last == participant.score {
                // 점수가 같으면 동일 순위
                result.append(Participant(name: participant.name, score: participant.score, rank: rank))
            } else {
                // 점수가 다르면 순위 갱신
                lastScore = participant.score
                result.append(Participant(name: participant.name, score: participant.score, rank: rank))
                rank += 1
            }
        }
        
        return result
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
                
                // DispatchGroup을 사용하여 모든 비동기 호출을 기다림
                let group = DispatchGroup()
                
                // 각 이벤트에 대해 멤버를 가져오고 점수를 계산
                for document in documents {
                    let data = document.data()
                    
                    // 해당 이벤트의 참여자 리스트 가져오기
                    if let participantsList = data["participants"] as? [String] {
                        for participantId in participantsList {
                            group.enter() // 비동기 호출 시작
                            
                            // 해당 멤버의 점수를 Firestore에서 가져옴
                            db.collection("users").document(participantId).getDocument { userSnapshot, error in
                                if let error = error {
                                    print("Error fetching user data: \(error.localizedDescription)")
                                    group.leave() // 비동기 호출 끝
                                } else if let userData = userSnapshot?.data() {
                                    if let nickname = userData["nickname"] as? String {
                                        // 멤버의 점수 가져오기 (해당 이벤트에서의 제출 상태 확인)
                                        db.collection("Submission")
                                            .whereField("eventId", isEqualTo: document.documentID)
                                            .whereField("memberId", isEqualTo: participantId)
                                            .getDocuments { submissionSnapshot, error in
                                                if let error = error {
                                                    print("Error fetching submission data: \(error.localizedDescription)")
                                                    group.leave() // 비동기 호출 끝
                                                } else if let submissionDocuments = submissionSnapshot?.documents, let submissionDoc = submissionDocuments.first {
                                                    // 기본 점수 50점
                                                    var score = 50
                                                    
                                                    // 제출 상태가 true이면 중요도만큼 추가
                                                    if let isSubmitted = submissionDoc["isSubmitted"] as? Bool, isSubmitted {
                                                        if let importance = document["importance"] as? Int {
                                                            score += importance
                                                        }
                                                    }
                                                    
                                                    // 점수와 이름을 Participant 배열에 추가
                                                    let participant = Participant(name: nickname, score: score, rank: 0) // rank는 나중에 설정됨
                                                    participants.append(participant)
                                                }
                                                group.leave() // 비동기 호출 끝
                                            }
                                    }
                                } else {
                                    group.leave() // 비동기 호출 끝
                                }
                            }
                        }
                    }
                }
                
                // 모든 비동기 작업이 끝나면 participants 배열을 업데이트
                group.notify(queue: .main) {
                    // participants 배열을 덮어쓰도록 수정
                    self.participants = participants
                }
            }
    }
}

struct Participant {
    let name: String
    let score: Int
    var rank: Int // 순위 추가
}

#Preview {
    ParticipationRankingView(projectName: "소프트웨어 스튜디오 2")
}
