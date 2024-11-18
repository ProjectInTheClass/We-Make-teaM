import SwiftUI

struct NotificationSettingsView: View {
    @State private var pushNotificationsEnabled: Bool = true

    var body: some View {
        Toggle("푸시 알림", isOn: $pushNotificationsEnabled)
            .padding()
            .onChange(of: pushNotificationsEnabled) { newValue in
                print("푸시 알림 설정 변경됨: \(newValue)")
                // 푸시 알림 설정 로직 추가
            }
        Spacer()
    }
}

