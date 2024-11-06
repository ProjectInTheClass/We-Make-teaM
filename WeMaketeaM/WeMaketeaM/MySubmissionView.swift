//프로젝트 홈화면 -> 나의 제출

import SwiftUI

struct MySubmissionView: View {
    var body: some View {
        VStack {
            Text("참여 순위")
                .font(.largeTitle)
                .padding()
            Spacer()
        }
        .navigationTitle("참여 순위")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MySubmissionView()
}
