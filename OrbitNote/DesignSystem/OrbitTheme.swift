import SwiftUI
import UIKit

enum OrbitTheme {
    static let background = Color(hex: 0x030407)
    static let surface = Color(hex: 0x0D1016)
    static let elevatedSurface = Color(hex: 0x121722)
    static let glassSurface = Color.white.opacity(0.10)
    static let orbitLine = Color(hex: 0xBCEEFF).opacity(0.14)
    static let positive = Color(hex: 0x63E8FF)
    static let draining = Color(hex: 0xFF7A66)
    static let neutral = Color(hex: 0xA99CFF)
    static let textPrimary = Color(hex: 0xF3F7FA)
    static let textSecondary = Color(hex: 0x8B94A7)
    static let borderSubtle = Color.white.opacity(0.12)

    static let largeTitle = Font.system(size: 34, weight: .semibold, design: .rounded)
    static let pageTitle = Font.system(size: 22, weight: .semibold)
    static let body = Font.system(size: 16, weight: .regular)
    static let caption = Font.system(size: 12, weight: .medium)
    static let numeric = Font.system(size: 13, weight: .medium, design: .monospaced)
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

enum GlassTabBar {
    static func configure() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        appearance.backgroundColor = UIColor(white: 0.03, alpha: 0.76)
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(white: 0.62, alpha: 1)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(white: 0.62, alpha: 1)]
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(OrbitTheme.positive)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(OrbitTheme.positive)]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

extension LinearGradient {
    static var auroraWash: LinearGradient {
        LinearGradient(
            colors: [
                OrbitTheme.positive.opacity(0.24),
                OrbitTheme.neutral.opacity(0.14),
                OrbitTheme.draining.opacity(0.10),
                .clear
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
