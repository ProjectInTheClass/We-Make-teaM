//각 프로젝트 홈페이지
import SwiftUI

struct ProjectHomeView: View {
    var projectName: String

    var body: some View {
        ZStack {
            VStack {
                Spacer()
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
                    VStack {
                        Image(systemName: "person.3")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("참여순위")
                    }
                }
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                HStack {
                    VStack {
                        Image(systemName: "doc.text")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("나의 제출")
                    }
                    Spacer()
                    VStack {
                        Image(systemName: "gearshape")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("환경설정")
                    }
                }
                .padding(.bottom, 20)
            }
            .padding()
            Spacer()
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
        }
        .navigationTitle(projectName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ProjectHomeView(projectName: "소프트웨어 스튜디오 2")
}
