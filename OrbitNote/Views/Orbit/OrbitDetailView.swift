import SwiftUI

struct OrbitDetailView: View {
    @EnvironmentObject private var store: OrbitStore
    @Environment(\.dismiss) private var dismiss
    let entry: OrbitEntry
    @State private var currentEntry: OrbitEntry
    @State private var showingEdit = false
    @State private var showingDeleteConfirmation = false

    init(entry: OrbitEntry) {
        self.entry = entry
        _currentEntry = State(initialValue: entry)
    }

    var body: some View {
        ZStack {
            AuroraBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    hero
                    metrics
                    note
                    suggestion
                    actions
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
        .fullScreenCover(isPresented: $showingEdit) {
            NavigationStack {
                AddEntryView(mode: .modal, editingEntry: currentEntry) {
                    if let updated = store.entry(id: currentEntry.id) {
                        currentEntry = updated
                    }
                    showingEdit = false
                }
            }
            .preferredColorScheme(.dark)
        }
        .alert("Delete orbit point?", isPresented: $showingDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                store.delete(currentEntry)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This removes the point from local data. It cannot be undone.")
        }
    }

    private var hero: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 18) {
                OrbitPoint(entry: currentEntry)
                    .frame(width: 76, height: 76)

                VStack(alignment: .leading, spacing: 8) {
                    Text(currentEntry.title)
                        .font(.system(size: 30, weight: .semibold, design: .rounded))
                        .foregroundStyle(OrbitTheme.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)

                    HStack {
                        CategoryPill(category: currentEntry.category)
                        EnergyPill(energy: currentEntry.energyType)
                    }
                }
            }
        }
    }

    private var metrics: some View {
        GlassCard {
            VStack(spacing: 16) {
                MetricRow(title: "Energy", value: currentEntry.energyType.shortTitle, color: currentEntry.energyType.color)
                MetricRow(title: "Impact", value: "\(currentEntry.intensity) / 5", color: currentEntry.energyType.color)
                MetricRow(title: "Distance", value: currentEntry.distance.title, color: OrbitTheme.textPrimary)
                MetricRow(title: "Category", value: currentEntry.category.title, color: OrbitTheme.textPrimary)
            }
        }
    }

    private var note: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 10) {
                SectionLabel("Note")
                Text("\"\(currentEntry.note)\"")
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

    private var actions: some View {
        GlassCard {
            VStack(spacing: 12) {
                Button {
                    showingEdit = true
                } label: {
                    Label("Edit orbit point", systemImage: "slider.horizontal.3")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .foregroundStyle(OrbitTheme.background)
                        .background(Capsule().fill(OrbitTheme.positive))
                }
                .buttonStyle(PressScaleButtonStyle())

                Button(role: .destructive) {
                    showingDeleteConfirmation = true
                } label: {
                    Label("Delete", systemImage: "trash")
                        .font(.system(size: 15, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .foregroundStyle(OrbitTheme.draining)
                        .background(Capsule().fill(OrbitTheme.draining.opacity(0.12)))
                }
                .buttonStyle(PressScaleButtonStyle())
            }
        }
    }

    private var suggestionCopy: String {
        switch currentEntry.energyType {
        case .draining where currentEntry.intensity >= 4:
            return "It is strongly draining you. Tomorrow, try placing it farther away before it becomes the center."
        case .positive where currentEntry.intensity >= 4:
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
