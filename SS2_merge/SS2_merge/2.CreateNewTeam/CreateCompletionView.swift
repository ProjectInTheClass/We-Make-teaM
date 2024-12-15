import SwiftUI

struct CompletionView: View {
    @Environment(\.dismiss) var dismiss
    var project: Project

    var onConfirm: () -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.yellow
                    .opacity(0.25)
                    .ignoresSafeArea()
                
                VStack(alignment: .center, spacing: 2) {
                    Image("plane2")
                        .resizable()
                        .frame(width: 360, height: 280)
                    // 상단 섹션
                    VStack(spacing: 5) {
                        Text(project.teamName)
                            .font(.system(size: 33, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                            //.shadow(color: .yellow.opacity(0.4), radius: 2, x: 0, y: 3) // 음영 효과 추가
                        
                        Text("프로젝트가 생성되었습니다.")
                            .font(.title2)
                            .fontDesign(.rounded)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                    .offset(y: -35)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 10)
        
                    // 내용 섹션
                
                    VStack(spacing: 70) {
                        VStack(spacing: 30) {
                            InfoSection(title: "방 ID", value: project.id.uuidString)
                            InfoSection(title: "방 비밀번호", value: project.teamPWD)
                        }
                        .frame(maxWidth: .infinity)
                        
                        // 확인 버튼
                        Button(action: {
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
                                .cornerRadius(10)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, geometry.size.width * 0) // 좌우 여백
                    Spacer()
                    Spacer()
                    Spacer()
                }
                .frame(maxHeight: .infinity)
                .padding()
                .offset(y:-30)
            }
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
    }
}


// InfoSection 재사용 가능한 뷰
struct InfoSection: View {
    var title: String
    var value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 18, weight: .regular, design: .rounded))
                .foregroundColor(.black)
            
            HStack(spacing: 15) {
                Text(value)
                    .padding()
                    .frame(height: 20)
                    .frame(minWidth: 170)
                    .cornerRadius(3)
                    .contextMenu {
                        Button(action: {
                            UIPasteboard.general.string = value
                        }) {
                            Label("복사", systemImage: "doc.on.doc")
                        }
                    }
                
                Button(action: {
                    UIPasteboard.general.string = value
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
        project: Project(teamName: "소프트웨어 스튜디오 2", teamPWD: "0000", year: 2024, semester: 1)
    ) {}
}
