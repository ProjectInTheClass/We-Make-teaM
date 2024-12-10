import SwiftUI

struct CompletionView: View {
    @Environment(\.dismiss) var dismiss
    var teamName: String
    var teamPWD: String
    var teamID: String
    @Binding var projects: [String]
    var onConfirm: () -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.yellow
                    .opacity(0.3)
                    .ignoresSafeArea()
                
                VStack(alignment: .center, spacing: 2) {
                    Image("colored_plane")
                        .resizable()
                        .frame(width: 340, height: 260)
                    // 상단 섹션
                    VStack(spacing: 5) {
                        Text(teamName)
                            .font(.system(size: 38, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                            //.shadow(color: .yellow.opacity(0.4), radius: 2, x: 0, y: 3) // 음영 효과 추가
                        
                        Text("팀이 생성되었습니다.")
                            .fontDesign(.rounded)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                    .offset(y: -35)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 30)
        
                    // 내용 섹션
                
                    VStack(spacing: 70) {
                        VStack(spacing: 30) {
                            InfoSection(title: "방 ID", ID: teamID, PWD: teamPWD)
                            InfoSection(title: "방 비밀번호", ID: teamPWD, PWD: teamPWD)
                        }
                        .frame(maxWidth: .infinity)
                        
                        // 확인 버튼
                        Button(action: {
                            projects.append(teamName)
                            onConfirm()
                        }) {
                            Text("확인")
                                .font(.title2)
                                .fontWeight(.heavy)
                                .fontDesign(.monospaced)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 300, height: 60)
                                .background(Color.black)
                                .cornerRadius(30)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, geometry.size.width * 0) // 좌우 여백
                    Spacer()
                }
                .frame(maxHeight: .infinity)
                .padding()
            }
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
    }
}


// InfoSection 재사용 가능한 뷰
struct InfoSection: View {
    var title: String
    var ID: String
    var PWD: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 18, weight: .regular, design: .rounded))
                .foregroundColor(.black)
            
            HStack(spacing: 15) {
                Text(ID)
                    .padding()
                    .frame(height: 20)
                    .frame(minWidth: 170)
                    .cornerRadius(3)
                    .contextMenu {
                        Button(action: {
                            UIPasteboard.general.string = PWD
                        }) {
                            Label("복사", systemImage: "doc.on.doc")
                        }
                    }
                
                Button(action: {
                    UIPasteboard.general.string = PWD
                }) {
                    Text("복사")
                        .fontWeight(.regular)
                        .foregroundColor(.black)
                        .frame(width: 70, height: 40)
                        .background(Color.yellow.opacity(0.2))
                        .cornerRadius(0)
                        .border(Color.black, width: 2)
                }
            }
            .background(Color.white)
            .frame(height: 40)
            .border(Color.black, width: 2)
        }
        .padding(.leading, 0)
    }
}

#Preview {
    CompletionView(
        teamName: "소프트웨어 스튜디오 2",
        teamPWD: "0000",
        teamID: "abcdefg",
        projects: .constant(["소프트웨어 스튜디오 2"])
    ) {}
}
