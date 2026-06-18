import SwiftUI

struct OnboardingView: View {
    var onFinish: () -> Void

    var body: some View {
        ZStack {
            AuroraBackground()

            VStack(alignment: .leading, spacing: 24) {
                Spacer(minLength: 16)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Orbit Note")
                        .font(OrbitTheme.largeTitle)
                        .foregroundStyle(OrbitTheme.textPrimary)
                    Text("A quiet map of what circles your attention.")
                        .font(OrbitTheme.body)
                        .foregroundStyle(OrbitTheme.textSecondary)
                }

                VStack(spacing: 12) {
                    OnboardingCard(
                        symbol: "book.closed",
                        title: "Not a diary",
                        message: "You do not need to write the whole day. Capture what stayed in your field."
                    )
                    OnboardingCard(
                        symbol: "orbit",
                        title: "Record what orbits you",
                        message: "People, projects, tasks, body signals, money, and unknown background noise."
                    )
                    OnboardingCard(
                        symbol: "scope",
                        title: "See distance and energy",
                        message: "Near means attention. Cyan gives energy. Peach drains. Violet stays neutral."
                    )
                }

                Spacer(minLength: 12)

                Button {
                    onFinish()
                } label: {
                    Text("Begin")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .foregroundStyle(OrbitTheme.background)
                        .background(Capsule().fill(OrbitTheme.positive))
                }
                .buttonStyle(PressScaleButtonStyle())

                Button {
                    onFinish()
                } label: {
                    Text("Skip")
                        .font(OrbitTheme.caption)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .foregroundStyle(OrbitTheme.textSecondary)
                }
            }
            .padding(20)
        }
    }
}

private struct OnboardingCard: View {
    let symbol: String
    let title: String
    let message: String

    var body: some View {
        GlassCard(cornerRadius: 22) {
            HStack(alignment: .top, spacing: 14) {
                Image(systemName: symbol)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(OrbitTheme.positive)
                    .frame(width: 34, height: 34)
                    .background(Circle().fill(OrbitTheme.positive.opacity(0.12)))

                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(OrbitTheme.textPrimary)
                    Text(message)
                        .font(OrbitTheme.caption)
                        .foregroundStyle(OrbitTheme.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}
