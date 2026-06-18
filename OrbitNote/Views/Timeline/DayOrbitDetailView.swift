import SwiftUI

struct DayOrbitDetailView: View {
    @EnvironmentObject private var store: OrbitStore
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

                    if currentEntries.isEmpty {
                        EmptyState(
                            title: "This day is clear",
                            message: "There are no orbit points left for this day."
                        )
                    } else {
                        OrbitCanvas(entries: currentEntries) { entry in
                            selectedEntry = entry
                        }
                        .frame(height: 360)

                        entryList
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

    private var currentEntries: [OrbitEntry] {
        store.entries(for: day.date)
    }

    private var currentDay: OrbitDay {
        OrbitDay(date: day.date, entries: currentEntries)
    }

    private var entryList: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 14) {
                SectionLabel("Dominant energy", value: currentDay.dominantEnergy.shortTitle)
                ForEach(currentEntries) { entry in
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
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
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
}
