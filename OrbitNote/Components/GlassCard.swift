import SwiftUI

struct GlassCard<Content: View>: View {
    var cornerRadius: CGFloat = 24
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(OrbitTheme.glassSurface)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .stroke(OrbitTheme.borderSubtle, lineWidth: 1)
                    )
            )
    }
}

struct PressScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.spring(response: 0.24, dampingFraction: 0.84), value: configuration.isPressed)
    }
}

struct AuroraBackground: View {
    var body: some View {
        ZStack {
            OrbitTheme.background.ignoresSafeArea()

            Circle()
                .fill(OrbitTheme.positive.opacity(0.18))
                .frame(width: 260, height: 260)
                .blur(radius: 80)
                .offset(x: -150, y: -260)

            Circle()
                .fill(OrbitTheme.neutral.opacity(0.13))
                .frame(width: 300, height: 300)
                .blur(radius: 95)
                .offset(x: 160, y: -130)

            Circle()
                .fill(OrbitTheme.draining.opacity(0.08))
                .frame(width: 240, height: 240)
                .blur(radius: 90)
                .offset(x: 140, y: 330)
        }
    }
}

struct SectionLabel: View {
    let title: String
    let value: String?

    init(_ title: String, value: String? = nil) {
        self.title = title
        self.value = value
    }

    var body: some View {
        HStack {
            Text(title.uppercased())
                .font(OrbitTheme.caption)
                .foregroundStyle(OrbitTheme.textSecondary)
            Spacer()
            if let value {
                Text(value)
                    .font(OrbitTheme.numeric)
                    .foregroundStyle(OrbitTheme.textPrimary)
            }
        }
    }
}
