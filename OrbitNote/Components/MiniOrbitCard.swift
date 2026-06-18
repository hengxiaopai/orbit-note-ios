import SwiftUI

struct MiniOrbitCard: View {
    let day: OrbitDay

    var body: some View {
        GlassCard(cornerRadius: 22) {
            HStack(spacing: 16) {
                OrbitCanvas(entries: day.entries, compact: true)
                    .frame(width: 96, height: 96)
                    .allowsHitTesting(false)

                VStack(alignment: .leading, spacing: 8) {
                    Text(day.date.formatted(.dateTime.weekday(.wide).month(.abbreviated).day()))
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(OrbitTheme.textPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    Text("\(day.entries.count) orbit points")
                        .font(OrbitTheme.caption)
                        .foregroundStyle(OrbitTheme.textSecondary)

                    EnergyPill(energy: day.dominantEnergy)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(OrbitTheme.textSecondary)
            }
        }
    }
}
