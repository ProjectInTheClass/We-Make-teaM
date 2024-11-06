//프로젝트 홈화면 -> 참여도 순위
import SwiftUI

struct ParticipationRankingView: View {
    var teamName: String  // Project name passed from ProjectHomeView
        @State private var currentDate = Date()
        @State private var participants = [
            Participant(name: "김현경", score: 80),
            Participant(name: "신준용", score: 70),
            Participant(name: "정광석", score: 55)
        ]
        
        var body: some View {
            VStack(spacing: 20) {
                HStack {
                    Text(teamName)
                        .font(.title)
                        .bold()
                    Spacer()
                    Button(action: {
                        // Dismiss action or navigation back
                    }) {
                        Image(systemName: "xmark")
                            .font(.title)
                    }
                }
                .padding(.horizontal)
                
                Text("\"\(formattedDate)\" 까지\n참여도 순위")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)
                
                RankingPodiumView(participants: participants)
                
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(participants, id: \.name) { participant in
                        Text("\(participant.name): \(participant.score)점")
                    }
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .padding()
            .navigationTitle("참여도 순위")
            .navigationBarBackButtonHidden(true)
        }
        
        // Format the current date
        private var formattedDate: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd"
            return formatter.string(from: currentDate)
        }
    }

    struct RankingPodiumView: View {
        var participants: [Participant]
        
        var body: some View {
            HStack(alignment: .bottom, spacing: 30) {
                // 2nd place
                if participants.indices.contains(1) {
                    VStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text(participants[1].name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("2")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .padding(.top, 30)
                }
                
                // 1st place
                if participants.indices.contains(0) {
                    VStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                        Text(participants[0].name)
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("1")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    .padding(.top, 10)
                }
                
                // 3rd place
                if participants.indices.contains(2) {
                    VStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text(participants[2].name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("3")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .padding(.top, 30)
                }
            }
        }
    }

    struct Participant {
        let name: String
        let score: Int
    }

    #Preview {
        ParticipationRankingView(teamName: "소프트웨어 스튜디오 2")
    }
