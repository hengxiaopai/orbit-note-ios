import SwiftUI

struct OrbitSummaryCard: View {
    let closest: OrbitEntry?
    let draining: OrbitEntry?
    let positive: OrbitEntry?

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label("Today summary", systemImage: "scope")
                        .font(OrbitTheme.caption)
                        .foregroundStyle(OrbitTheme.textSecondary)
                    Spacer()
                    Text("LIVE")
                        .font(OrbitTheme.numeric)
                        .foregroundStyle(OrbitTheme.positive)
                }

                SummaryRow(title: "Closest to me", entry: closest, fallback: "No strong pull yet")
                SummaryRow(title: "Most draining", entry: draining, fallback: "No clear drain")
                SummaryRow(title: "Most energizing", entry: positive, fallback: "No bright source yet")
            }
        }
    }
}

private struct SummaryRow: View {
    let title: String
    let entry: OrbitEntry?
    let fallback: String

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill((entry?.energyType.color ?? OrbitTheme.textSecondary).opacity(0.8))
                .frame(width: 8, height: 8)
                .shadow(color: (entry?.energyType.color ?? .clear).opacity(0.4), radius: 8)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(OrbitTheme.caption)
                    .foregroundStyle(OrbitTheme.textSecondary)
                Text(entry?.title ?? fallback)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(OrbitTheme.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.78)
            }
            Spacer()
            if let entry {
                Text("\(entry.intensity)")
                    .font(OrbitTheme.numeric)
                    .foregroundStyle(entry.energyType.color)
            }
        }
    }
}
