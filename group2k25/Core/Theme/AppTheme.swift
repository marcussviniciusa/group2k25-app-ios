import SwiftUI

enum AppTheme {
    static let cornerRadius: CGFloat = 16
    static let cardCornerRadius: CGFloat = 20
    static let buttonCornerRadius: CGFloat = 12
    static let spacing: CGFloat = 16
    static let smallSpacing: CGFloat = 8
    static let largeSpacing: CGFloat = 24

    static let primaryGradient = LinearGradient(
        colors: [Color.appPrimary, Color.appSecondary],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let backgroundGradient = LinearGradient(
        colors: [
            Color(hex: "000000"),
            Color(hex: "121212"),
            Color(hex: "000000")
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
