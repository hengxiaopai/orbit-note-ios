import SwiftUI

struct EmptyState: View {
    var body: some View {
        GlassCard {
            VStack(spacing: 14) {
                ZStack {
                    Circle()
                        .stroke(OrbitTheme.orbitLine, lineWidth: 1)
                        .frame(width: 74, height: 74)
                    Image(systemName: "orbit")
                        .font(.system(size: 26, weight: .medium))
                        .foregroundStyle(OrbitTheme.positive)
                }

                Text("No orbit points yet")
                    .font(OrbitTheme.pageTitle)
                    .foregroundStyle(OrbitTheme.textPrimary)

                Text("Add one thing that stayed around your attention today.")
                    .font(OrbitTheme.body)
                    .foregroundStyle(OrbitTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
