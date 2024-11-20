//환경설정
import SwiftUI

struct ContactSupportView: View {
    var body: some View {
        VStack {
            Text("문의 사항이 있으신가요?")
                .padding()

            Button("고객 지원 문의하기") {
                print("문의하기 버튼 클릭됨")
                // 이메일 또는 고객 지원 페이지로 연결
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .navigationTitle("문의하기")
    }
}

