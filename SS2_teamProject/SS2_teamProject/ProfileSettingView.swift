import SwiftUI

struct ProfileSettingsView: View {
    @State private var nickname: String = ""

    var body: some View {
        VStack {
            TextField("닉네임 입력", text: $nickname)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("저장") {
                print("닉네임 저장됨: \(nickname)")
                // 실제 저장 로직 구현
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .navigationTitle("프로필 관리")
    }
}
