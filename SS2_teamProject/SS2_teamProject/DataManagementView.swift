import SwiftUI

struct DataManagementView: View {
    var body: some View {
        VStack {
            Button("데이터 초기화") {
                print("데이터 초기화됨")
                // 데이터 초기화 로직 추가
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .navigationTitle("데이터 관리")
    }
}

