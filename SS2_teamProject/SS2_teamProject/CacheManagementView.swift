import SwiftUI

struct CacheManagementView: View {
    var body: some View {
        VStack {
            Button("캐시 데이터 삭제") {
                print("캐시 데이터 삭제됨")
                // 캐시 데이터 삭제 로직 추가
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .navigationTitle("캐시 데이터 관리")
    }
}

