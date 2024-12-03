import SwiftUI

struct ProjectHomeView: View {
    var projectName: String
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        ZStack(){
            Color.yellow
                .opacity(0.2)
                .ignoresSafeArea()
            VStack {
                Spacer()
                ZStack {
                    Image("colored_plane")
                        .resizable()
                        .frame(width:420, height:270)
                        .offset(x: 0, y: 0)
                   // Image("cloud")
                     //   .resizable()
                      //  .frame(width:420, height:270)
                        //.offset(x: 0, y: 70)
            
                    Image("char3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 280, height: 280)
                    ZStack{
                        Text(projectName)
                            .font(.system(size: 35, weight: .black, design: .rounded))
                            .padding(.top, 5)
                            .offset(y: 170)
                    }
                }
                Spacer()
                Spacer()
                // 주요 기능 버튼 섹션
                HStack {
                    Spacer()
                    NavigationLink(destination: MySubmissionView(projectName: projectName, teamMembers: [
                        TeamMember(name: "Alice", score: 90, profileImage: Image(systemName: "person.fill")),
                        TeamMember(name: "Bob", score: 85, profileImage: Image(systemName: "person.fill")),
                        TeamMember(name: "Charlie", score: 95, profileImage: Image(systemName: "person.fill")),
                        TeamMember(name: "Dave", score: 80, profileImage: Image(systemName: "person.fill")),
                        TeamMember(name: "Eve", score: 88, profileImage: Image(systemName: "person.fill"))
                    ])) {  // Project 객체를 넘김
                        VStack {
                            //Image(systemName: "doc.text")
                            Image("mySubmission3")
                                .resizable()
                                .frame(width: 75, height: 80)
                                .foregroundColor(.black)
                            Text("나의 제출")
                                .frame(width: 90)
                                //.background(Color.white)
                                .cornerRadius(5)
                                .foregroundColor(.black)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                //.overlay(
                                //    RoundedRectangle(cornerRadius: 3)
                                //        .stroke(Color.black, lineWidth: 2)
                                //    )
                        }
                    }
                    Spacer()
                    Spacer()
                    NavigationLink(destination: CalendarView(projectName: projectName)) {  // Project 객체를 넘김
                        VStack {
                            //Image(systemName: "calendar")
                            Image("calendar3")
                                .resizable()
                                .frame(width: 84, height: 84)
                            Text("캘린더")
                                .frame(width: 80)
                                //.background(Color.white)
                                .cornerRadius(5)
                                .foregroundColor(.black)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                //.border(Color.black, width:2)
                                //.overlay(
                                //    RoundedRectangle(cornerRadius: 3)
                                //        .stroke(Color.black, lineWidth: 2)
                                //    )
                        }
                    }
                    
                    Spacer()
                    Spacer()
                    NavigationLink(destination: ParticipationRankingView(projectName: projectName)) {  // Project 객체를 넘김
                        VStack {
                            //Image(systemName: "person.3")
                            Image("ranking")
                                .resizable()
                                .frame(width: 75, height: 85)

                            Text("참여순위")
                                .frame(width: 90)
                                //.background(Color.white)
                                .cornerRadius(5)
                                .foregroundColor(.black)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                //.overlay(
                                //    RoundedRectangle(cornerRadius: 3)
                                //        .stroke(Color.black, lineWidth: 2)
                                //    )
                            
                        }
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 180)
                //.background(Color.yellow.opacity(0.2))
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
}

#Preview {
    ProjectHomeView(projectName: "소프트웨어 스튜디오 2")
        .environmentObject(NavigationManager()) // NavigationManager를 environmentObject로 제공
}


