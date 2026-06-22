import SwiftUI

struct TodayInsightCard: View {
    let insight: TodayOrbitInsight

    var body: some View {
        GlassCard(cornerRadius: 22) {
            VStack(alignment: .leading, spacing: 12) {
                Label("Today insight", systemImage: "sparkle.magnifyingglass")
                    .font(OrbitTheme.caption)
                    .foregroundStyle(OrbitTheme.textSecondary)

                Text(insight.headline)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(OrbitTheme.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)

                Text(insight.summary)
                    .font(OrbitTheme.body)
                    .foregroundStyle(OrbitTheme.textSecondary)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)

                VStack(alignment: .leading, spacing: 5) {
                    Text("Gentle prompt")
                        .font(OrbitTheme.caption)
                        .foregroundStyle(OrbitTheme.textSecondary)

                    Text(insight.suggestedPrompt)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(OrbitTheme.textPrimary)
                        .lineSpacing(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.top, 2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityCopy)
    }

    private var accessibilityCopy: String {
        "Today insight. \(insight.headline). \(insight.summary). Gentle prompt. \(insight.suggestedPrompt)"
    }
}

#Preview("Empty") {
    TodayInsightCard(
        insight: TodayOrbitInsight(
            generatedAt: Date(),
            date: Date(),
            entryCount: 0,
            headline: "No orbit yet",
            summary: "There are no orbit points for today yet. A single point is enough to begin seeing what stayed close.",
            focusTitle: nil,
            positiveTitle: nil,
            drainingTitle: nil,
            suggestedPrompt: "What has taken the most attention today?"
        )
    )
    .padding()
    .background(AuroraBackground())
    .preferredColorScheme(.dark)
}

#Preview("With entries") {
    TodayInsightCard(
        insight: TodayOrbitInsight(
            generatedAt: Date(),
            date: Date(),
            entryCount: 4,
            headline: "Energy is gathering",
            summary: "Today has 4 orbit points. Morning walk is closest to your attention, with Studio draft giving the clearest lift.",
            focusTitle: "Morning walk",
            positiveTitle: "Studio draft",
            drainingTitle: "Budget review",
            suggestedPrompt: "What small space can you keep for Studio draft tomorrow?"
        )
    )
    .padding()
    .background(AuroraBackground())
    .preferredColorScheme(.dark)
}
