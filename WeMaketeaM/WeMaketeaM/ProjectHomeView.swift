//2. 프로젝트방의 홈화면 
import SwiftUI

struct ProjectHomeView: View {
    var projectName: String
    @EnvironmentObject var navigationManager: NavigationManager // NavigationManager 사용

    var body: some View {
    
        VStack {
            Spacer()
            VStack {
                Image("homeChar")  // 캐릭터 이미지
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                
                Text(projectName)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 10)
            }
            
            Spacer()
            // 주요 기능 버튼 섹션
            HStack {
                NavigationLink(destination: CalendarView()) {  // CalendarView로 연결
                    VStack {
                        Image(systemName: "calendar")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("캘린더")
                    }
                }
                Spacer()
                NavigationLink(destination: ParticipationRankingView(teamName:"소프트웨어 스튜디오2")) {  // 참여 순위로 연결
                    VStack {
                        Image(systemName: "person.3")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("참여순위")
                    }
                }
                Spacer()
                NavigationLink(destination: MySubmissionView(projectName: projectName, teamMembers: [
                    TeamMember(name: "Alice", score: 90, profileImage: Image(systemName: "person.fill")),
                    TeamMember(name: "Bob", score: 85, profileImage: Image(systemName: "person.fill")),
                    TeamMember(name: "Charlie", score: 95, profileImage: Image(systemName: "person.fill")),
                    TeamMember(name: "Dave", score: 80, profileImage: Image(systemName: "person.fill")),
                    TeamMember(name: "Eve", score: 88, profileImage: Image(systemName: "person.fill"))
                ]))
                {  // 나의 제출로 연결
                    VStack {
                        Image(systemName: "doc.text")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("나의 제출")
                    }
                }
                
                
            }
            .padding(.horizontal, 40)
            Spacer()

        }
        .navigationTitle(projectName)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: HStack {
            // WMM 로고 버튼 (메인 페이지 이동)
            Button(action: {
                navigationManager.resetToRoot() // 루트로 이동하는 함수 호출
            }) {
                Text("WMM")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            
            // 환경설정 아이콘 버튼 (설정 페이지 이동)
            NavigationLink(destination: SettingsView()) {
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.black)
            }
        })
    }
}

#Preview {
    ProjectHomeView(projectName: "소프트웨어 스튜디오 2")
        .environmentObject(NavigationManager()) // NavigationManager를 environmentObject로 제공
}
