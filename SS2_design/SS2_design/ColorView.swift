import SwiftUI

extension Color {
    static let customYellow = Color(red: 1.0, green: 0.9, blue: 0.0)
    static let customBlue = Color(hex: "#1E90FF") // HEX 값 사용
}

// HEX 값을 지원하도록 Color 확장
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = hex.hasPrefix("#") ? 1 : 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let red = Double((rgbValue >> 16) & 0xff) / 255.0
        let green = Double((rgbValue >> 8) & 0xff) / 255.0
        let blue = Double(rgbValue & 0xff) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}

// 사용 예시
//Color.customYellow
//Color.customBlue


