import SwiftUI

struct ProjectHomeView: View {
    var projectName: String
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var isDarkMode: Bool = false // 스위치 상태
    @State private var selectedCharacter: String = "char3"
    @State private var selectedPlane: String = "colored_plane"
    @State private var navigateToSelectionView: Bool = false // 네비게이션 상태
    
    var body: some View {
        ZStack {
            Color.yellow
                .opacity(0.15)
                .ignoresSafeArea()
            
            VStack {
                // Toggle
                Toggle("", isOn: $isDarkMode)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: .yellow))
                    .frame(width: 60)
                    .padding()
                    .shadow(radius: 5)
                    .padding()
                    .onChange(of: isDarkMode) { newValue in
                        if newValue {
                            navigateToSelectionView = true
                        }
                    }
                
                // 네비게이션 링크
                NavigationLink(destination: CharacterAndPlaneSelectionView(selectedCharacter: $selectedCharacter, selectedPlane: $selectedPlane), isActive: $navigateToSelectionView) {
                    EmptyView()
                }
                
                ZStack {
                    Image(selectedPlane)
                        .resizable()
                        .frame(width: 420, height: 270)
                    
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
                

                
                // 주요 기능 버튼 섹션
                HStack {
                    Spacer()
                    
                    NavigationLink(destination: MySubmissionView(projectName: projectName, teamMembers: sampleTeamMembers)) {
                        featureButton(imageName: "mySubmission3", title: "나의 제출")
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: CalendarView()) {
                        featureButton(imageName: "calendar3", title: "캘린더")
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: ParticipationRankingView(projectName: projectName)) {
                        featureButton(imageName: "ranking", title: "참여순위")
                    }
                    
                    Spacer()
                }
                .frame(height: 180)
                .padding(.horizontal, 0)
                
                Spacer()
            }
            .navigationTitle("사용자 정보 관리")
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
    
    // 주요 기능 버튼을 생성하는 함수
    func featureButton(imageName: String, title: String) -> some View {
        VStack {
            Image(imageName)
                .resizable()
                .frame(width: 75, height: 80)
            
            Text(title)
                .frame(width: 90)
                .foregroundColor(.black)
                .font(.system(size: 20, weight: .bold, design: .rounded))
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

struct ProjectHomeView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectHomeView(projectName: "소프트웨어 스튜디오 2")
            .environmentObject(NavigationManager())
    }
}
