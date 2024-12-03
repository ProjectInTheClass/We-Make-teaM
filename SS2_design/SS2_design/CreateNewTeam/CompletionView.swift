//생성된 방 링크
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
                VStack(spacing: 0) {
                    // 상단 배경
                    Color.yellow
                        .opacity(0.3)
                        .frame(height: geometry.size.height * 0.22) // 비율 기반 상단 배경
                        .ignoresSafeArea(edges: .top)
                    
                    Spacer() // 나머지 화면은 흰색
                }
                
                VStack(alignment: .center, spacing: 50) {
                    // 상단 섹션
                    VStack(spacing: 8) {
                        Text(teamName)
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                        
                        Text("팀이 생성되었습니다.")
                            .fontDesign(.rounded)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 0)
                    .offset(y: 20)

                    // 내용 섹션
                    VStack(spacing: 40) {
                        VStack(spacing: 40) {
                            InfoSection(title: "프로젝트방 ID", ID: teamID, PWD: teamPWD)
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
                                .frame(width:250, height:50)
                                .background(Color.black)
                                .cornerRadius(8)
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
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.black)
            
            HStack(spacing: 15) {
                Text(ID)
                    .padding()
                    .frame(height: 40)
                    .frame(minWidth: 250)
                    
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
        projects: .constant(["소프트웨어 스튜디오2"])
    ) {}
}
