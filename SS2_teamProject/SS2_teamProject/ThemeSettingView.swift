import SwiftUI

struct ThemeSettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("selectedTheme") private var selectedTheme: String = "system"

    var body: some View {
        Picker("테마 설정", selection: $selectedTheme) {
            Text("시스템 기본값").tag("system")
            Text("라이트 모드").tag("light")
            Text("다크 모드").tag("dark")
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
        .onChange(of: selectedTheme) { newValue in
            print("테마 변경됨: \(newValue)")
            // 테마 변경 로직 추가
        }
    }
}

