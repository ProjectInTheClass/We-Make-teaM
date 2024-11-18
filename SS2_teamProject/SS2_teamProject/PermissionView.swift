import SwiftUI

struct PermissionsView: View {
    var body: some View {
        VStack {
            Button("푸시 알림 권한 요청") {
                requestPushNotificationPermissions()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .navigationTitle("사용자 동의 관리")
    }
    
    func requestPushNotificationPermissions() {
        print("푸시 알림 권한 요청됨")
        // UNUserNotificationCenter를 사용한 권한 요청 구현
    }
}

