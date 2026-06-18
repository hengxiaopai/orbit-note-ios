import SwiftUI

struct DayOrbitDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let day: OrbitDay
    @State private var selectedEntry: OrbitEntry?

    var body: some View {
        ZStack {
            AuroraBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(day.date.formatted(.dateTime.weekday(.wide).month(.wide).day()))
                            .font(OrbitTheme.caption)
                            .foregroundStyle(OrbitTheme.textSecondary)
                        Text("Day Orbit")
                            .font(OrbitTheme.largeTitle)
                            .foregroundStyle(OrbitTheme.textPrimary)
                    }

                    OrbitCanvas(entries: day.entries) { entry in
                        selectedEntry = entry
                    }
                    .frame(height: 360)

                    GlassCard {
                        VStack(alignment: .leading, spacing: 14) {
                            SectionLabel("Dominant energy", value: day.dominantEnergy.shortTitle)
                            ForEach(day.entries) { entry in
                                Button {
                                    selectedEntry = entry
                                } label: {
                                    HStack(spacing: 12) {
                                        Circle()
                                            .fill(entry.energyType.color)
                                            .frame(width: 9, height: 9)
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(entry.title)
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundStyle(OrbitTheme.textPrimary)
                                            Text("\(entry.category.title) · \(entry.distance.title)")
                                                .font(OrbitTheme.caption)
                                                .foregroundStyle(OrbitTheme.textSecondary)
                                        }
                                        Spacer()
                                        Text("\(entry.intensity)")
                                            .font(OrbitTheme.numeric)
                                            .foregroundStyle(entry.energyType.color)
                                    }
                                }
                                .buttonStyle(PressScaleButtonStyle())
                            }
                        }
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Day")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    dismiss()
                }
                .foregroundStyle(OrbitTheme.positive)
            }
        }
        .sheet(item: $selectedEntry) { entry in
            NavigationStack {
                OrbitDetailView(entry: entry)
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
            .preferredColorScheme(.dark)
        }
    }
}
