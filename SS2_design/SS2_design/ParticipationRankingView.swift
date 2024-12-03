//프로젝트 멤버들 전체 참여도 보기
import SwiftUI

struct ParticipationRankingView: View {
    var projectName: String
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var currentDate = Date()
    @State private var participants = [
        Participant(name: "김현경", score: 80, rank:1),
        Participant(name: "신준용", score: 70, rank:2),
        Participant(name: "정광석", score: 55, rank:3),
        Participant(name: "이수민", score: 40, rank:4)
    ]
    
    var body: some View {
        ScrollView{
            VStack(spacing: 10) {
                VStack(spacing: 0){
                    ZStack {
                        Text("Ranking View")
                            .font(.system(size: 50, weight: .bold, design: .rounded))
                            .frame(maxWidth: .infinity)
                        
                        //Image("char2")
                        //    .resizable()
                        //    .frame(width:90, height:90)
                        //    .offset(x:137, y:-16)

                    }
                    .padding(.top, 10)
                    HStack(){
                        Text("\(formattedDate)")
                            .foregroundColor(.red)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            
                        Text(" 까지의 참여도 순위")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .offset(x:-7)
                        
                    }
                    .offset(y: -0)
                    
    
                }
                
                
                RankingPodiumView(participants: Array(sortedParticipants.prefix(3)))
                
                VStack(spacing: 20) {
                    ForEach(sortedParticipants, id: \.name) { participant in
                        HStack(){
                            Text(" \(participant.rank) ")
                                .fontWeight(.bold)
                                .font(.title2)
                            Image("profile")
                                .resizable()
                                .frame(width: 70, height: 60)
                                .foregroundColor(.black)
                                .background(Color.white)
                            Spacer()
                            Text("\(participant.name): ")
                                .fontWeight(.bold)
                                .font(.title2)
                            Spacer()
                            Text("\(participant.score)점")
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                        }
                        .padding(10)
                        .frame(width:320, height: 70)
                        .border(Color.black, width:1)
                    }
                }
                .padding(.top, 20)
                
                Spacer()
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
}

struct RankingPodiumView: View {
    var participants: [Participant]
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 30) {
            // 2등
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
            
            // 1등
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
            
            // 3등
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
    let rank: Int
}

#Preview {
    ParticipationRankingView(projectName: "소프트웨어 스튜디오 2")
}

