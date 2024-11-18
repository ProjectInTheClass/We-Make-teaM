//각 프로젝트의 홈 페이지 <- ContentView
import SwiftUI

struct ProjectHomeView: View {
    var projectName: String
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        VStack {
            Image("homeChar")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .padding(.top, 100)
            
            Text(projectName)
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            
            HStack {
                NavigationLink(destination: CalendarView()) {
                    VStack {
                        Image(systemName: "calendar")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.black)
                        Text("캘린더")
                            .foregroundColor(.black)
                    }
                }
                Spacer()
                NavigationLink(destination: ParticipationRankingView(projectName: projectName)) {
                    VStack {
                        Image(systemName: "person.3")
                            .resizable()
                            .frame(width: 60, height: 50)
                            .foregroundColor(.black)

                        Text("참여순위")
                            .foregroundColor(.black)
                    }
                }
                Spacer()
                NavigationLink(destination: MySubmissionView(projectName: projectName, teamMembers: [
                    TeamMember(name: "Alice", score: 90, profileImage: Image(systemName: "person.fill")),
                    TeamMember(name: "Bob", score: 85, profileImage: Image(systemName: "person.fill")),
                    TeamMember(name: "Charlie", score: 95, profileImage: Image(systemName: "person.fill")),
                    TeamMember(name: "Dave", score: 80, profileImage: Image(systemName: "person.fill")),
                    TeamMember(name: "Eve", score: 88, profileImage: Image(systemName: "person.fill"))
                ])) {
                    VStack {
                        Image(systemName: "doc.text")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.black)

                        Text("나의제출")
                            .foregroundColor(.black)
                    }
                }
            }
            .padding(.top, 100)
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .navigationTitle(projectName)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: HStack {
            Button(action: {
                navigationManager.resetToRoot()
            }) {
                Text("WMM")
                    .font(.headline)
                    .foregroundColor(.blue)
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


#Preview{
    ProjectHomeView(projectName: "소프트웨어 스튜디오 2")
        .environmentObject(NavigationManager())
}
