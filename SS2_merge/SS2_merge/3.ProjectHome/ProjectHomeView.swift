import SwiftUI

struct ProjectHomeView: View {
    var projectName: String
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var isShowingChangeCharacterView = false
    
    @State private var selectedCharacter: String = "char3"
    @State private var selectedPlane: String = "pp3"

    var body: some View {
        ZStack(){
            Color.yellow
                .opacity(0.2)
                .ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        isShowingChangeCharacterView = true
                    }) {
                        Image("off")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                    .frame(maxWidth:.infinity)
                    .padding()
                }
                
                // NavigationLink로 ChangeCharacterView로 이동
                NavigationLink(destination: ChangeCharacterView(
                    selectedCharacter: $selectedCharacter,
                    selectedPlane: $selectedPlane
                ), isActive: $isShowingChangeCharacterView) {
                    EmptyView()
                }
                
                ZStack {
                    Image(selectedPlane)
                        .resizable()
                        .frame(width:420, height:270)
                
                    Image(selectedCharacter)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 280, height: 280)
                    Text(projectName)
                        .font(.system(size: 35, weight: .black, design: .rounded))
                        .padding(.top, 5)
                        .offset(y: 170)
                }
                Spacer()
                Spacer()
                // 주요 기능 버튼 섹션
                HStack {
                    Spacer()
                    NavigationLink(destination: MySubmissionView(projectName: projectName, teamMembers: sampleTeamMembers)) {
                        featureButton(imageName: "s", title: "나의 제출")
                    }
                    Spacer()
                    
                    NavigationLink(destination: CalendarView()) {
                        featureButton(imageName: "c2", title: "캘린더")
                    }
                    Spacer()
                    
                    NavigationLink(destination: ParticipationRankingView(projectName: projectName)) {
                        featureButton(imageName: "r", title: "참여순위")
                    }
                    Spacer()
                    
                }
                .frame(maxWidth: .infinity)
                .frame(height: 180)
                .padding(.horizontal, 0)
                Spacer()
                Spacer()
            }
            .navigationTitle(projectName)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: HStack {
                Button(action: {
                    debugPrint(navigationManager.path)
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
    func featureButton(imageName: String, title: String) -> some View {
        VStack {
            Image(imageName)
                .resizable()
                .frame(width: 65, height: 70)
            
            Text(title)
                .frame(width: 90)
                .foregroundColor(.black)
                .font(.system(size: 18, weight: .bold, design: .rounded))
        }
    }
    
    // 샘플 팀원 데이터
    let sampleTeamMembers = [
        TeamMember(name: "Alice", score: 90, profileImage: Image(systemName: "person.fill")),
        TeamMember(name: "Bob", score: 85, profileImage: Image(systemName: "person.fill")),
        TeamMember(name: "Charlie", score: 95, profileImage: Image(systemName: "person.fill")),
        TeamMember(name: "Dave", score: 80, profileImage: Image(systemName: "person.fill")),
        TeamMember(name: "Eve", score: 88, profileImage: Image(systemName: "person.fill"))
    ]
}

#Preview {
    ProjectHomeView(projectName: "소프트웨어 스튜디오 2")
        .environmentObject(NavigationManager()) // NavigationManager를 environmentObject로 제공
}
