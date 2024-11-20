//방 생성 완료와 함께 링크 제공
import SwiftUI

struct CompletionView: View {
    @Environment(\.dismiss) var dismiss
    var teamName: String
    @Binding var projects: [String]
    @State private var inviteLink: String =  "https://j/94997178477?pwd=aHdldlxlIskd"
    var onConfirm: () -> Void
    
    var body: some View {
        VStack(spacing: 20){
            Text(teamName)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            Text("팀 생성이 완료되었습니다.")
                .font(.headline)
            
            Text("아래링크를 통해\n팀원들을 초대하세요!")
                .multilineTextAlignment(.center)
                .font(.headline)
            
            Text("초대링크")
                .font(.headline)
                .foregroundColor(.red)
                .padding(.top, 10)
            
            Text(inviteLink)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .contextMenu{
                    Button(action:{
                        UIPasteboard.general.string=inviteLink
                    }){
                        Text("복사")
                        Image(systemName: "doc.on.doc")
                    }
                }
            
            Button(action:{
                UIPasteboard.general.string=inviteLink
            }){
                Text("복사")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .cornerRadius(8)
            }
            
            Button(action: {
                projects.append(teamName)
                onConfirm()
            }){
                Text("확인")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth:.infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .toolbar{
            //네비게이션 바 왼쪽에 버튼을 추가해 dismiss()를 호출해 화면을 닫는다.
            ToolbarItem(placement: .navigationBarLeading){
                
            }
        }
        
    }
}

#Preview{
    CompletionView(teamName: "소프트웨어 스튜디오 2", projects: .constant(["소프트웨어 스튜디오2"])){
        
    }
}
