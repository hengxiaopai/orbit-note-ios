import SwiftUI

struct OrbitDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let entry: OrbitEntry

    var body: some View {
        ZStack {
            AuroraBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    hero
                    metrics
                    note
                    suggestion
                }
                .padding(20)
            }
        }
        .navigationTitle("Orbit Point")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    dismiss()
                }
                .foregroundStyle(OrbitTheme.positive)
            }
        }
    }

    private var hero: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 18) {
                OrbitPoint(entry: entry)
                    .frame(width: 76, height: 76)

                VStack(alignment: .leading, spacing: 8) {
                    Text(entry.title)
                        .font(.system(size: 30, weight: .semibold, design: .rounded))
                        .foregroundStyle(OrbitTheme.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)

                    HStack {
                        CategoryPill(category: entry.category)
                        EnergyPill(energy: entry.energyType)
                    }
                }
            }
        }
    }

    private var metrics: some View {
        GlassCard {
            VStack(spacing: 16) {
                MetricRow(title: "Energy", value: entry.energyType.shortTitle, color: entry.energyType.color)
                MetricRow(title: "Impact", value: "\(entry.intensity) / 5", color: entry.energyType.color)
                MetricRow(title: "Distance", value: entry.distance.title, color: OrbitTheme.textPrimary)
                MetricRow(title: "Category", value: entry.category.title, color: OrbitTheme.textPrimary)
            }
        }
    }

    private var note: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 10) {
                SectionLabel("Note")
                Text("\"\(entry.note)\"")
                    .font(.system(size: 18, weight: .regular, design: .serif))
                    .foregroundStyle(OrbitTheme.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var suggestion: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 10) {
                Label("Tomorrow signal", systemImage: "sparkles")
                    .font(OrbitTheme.caption)
                    .foregroundStyle(OrbitTheme.textSecondary)

                Text(suggestionCopy)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(OrbitTheme.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var suggestionCopy: String {
        switch entry.energyType {
        case .draining where entry.intensity >= 4:
            return "It is strongly draining you. Tomorrow, try placing it farther away before it becomes the center."
        case .positive where entry.intensity >= 4:
            return "This is giving real energy. Keep a pocket of time for it before the day fills up."
        case .neutral:
            return "It is neutral for now. Watch whether it keeps moving closer across the week."
        case .draining:
            return "It is taking some energy. Give it a boundary before it grows brighter."
        case .positive:
            return "It is a quiet source of energy. Keep it visible."
        }
    }
}

private struct MetricRow: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        HStack {
            Text(title)
                .font(OrbitTheme.caption)
                .foregroundStyle(OrbitTheme.textSecondary)
            Spacer()
            Text(value)
                .font(OrbitTheme.numeric)
                .foregroundStyle(color)
        }
    }
}
