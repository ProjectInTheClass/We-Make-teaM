//프로젝트 멤버들 전체 참여도 보기
import SwiftUI

struct ParticipationRankingView: View {
    var projectName: String
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var currentDate = Date()
    @State private var participants = [
        Participant(name: "김현경", score: 80),
        Participant(name: "신준용", score: 70),
        Participant(name: "정광석", score: 55),
        Participant(name: "이수민", score: 40)
    ]
    
    var body: some View {
        ZStack(){
            Color.yellow
                .opacity(0.1)
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 5) {
                        VStack(spacing: 1){
                            Capsule()
                                .fill(Color.black)
                                .frame(height: 3)
                                .padding(.horizontal,30)
                            
                            Text("Team Ranking")
                                .font(.system(size: 41, weight: .bold, design: .rounded))
                                .frame(maxWidth: .infinity)
                                .padding()
                            
                            Capsule()
                                .fill(Color.black)
                                .frame(height: 3)
                                .padding(.horizontal,30)
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
                        //.offset(x: 65)
            
                    }
                    
                    VStack(spacing: 20) {
                        ForEach(Array(sortedParticipants.enumerated()), id: \.offset) { index, participant in
                            HStack {
                                Text(" \(index + 1) ")
                                    .fontWeight(.bold)
                                    .font(index == 0 ? .title : .title2) // 1등은 더 큰 글씨
                                Image("profile")
                                    .resizable()
                                    .frame(width: index == 0 ? 70 : 50, height: index == 0 ? 70 : 50) // 1등은 더 큰 이미지
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
                                    .offset(x:-10)
            
                            }
                            .padding(index == 0 ? 15 : 10) // 1등은 더 넓은 여백
                            .frame(width: index == 0 ? 350 : 320, height: index == 0 ? 90 : 70) // 1등은 더 큰 프레임
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

struct Participant {
    let name: String
    let score: Int
}

#Preview {
    ParticipationRankingView(projectName: "소프트웨어 스튜디오 2")
}

