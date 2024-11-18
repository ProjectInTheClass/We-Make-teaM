//해당 제출물에 대한 각 팀원들의 제출물 확인과 댓글기능
import SwiftUI

struct MemberSubmissionDetailView: View {
    var member: Member

    var body: some View {
        VStack {
            Text("\(member.name)의 제출물")
                .font(.largeTitle)
                .padding()

            // 여기에 실제 제출한 파일 목록이나 상세 내용을 표시
            Text("제출한 파일 1")
            Text("제출한 파일 2")
            Text("제출한 파일 3")
            
            Spacer()
        }
        .padding()
        .navigationTitle("\(member.name) 제출물")
    }
}

#Preview {
    MemberSubmissionDetailView(member: Member(name: "A", hasSubmitted: true))
}
