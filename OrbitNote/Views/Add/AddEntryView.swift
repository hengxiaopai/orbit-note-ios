import SwiftUI

enum AddEntryMode {
    case tab
    case modal
}

struct AddEntryView: View {
    @EnvironmentObject private var store: OrbitStore
    @Environment(\.dismiss) private var dismiss

    let mode: AddEntryMode
    var onSaved: () -> Void

    @State private var title = ""
    @State private var category: OrbitCategory = .project
    @State private var energyType: EnergyType = .positive
    @State private var intensity = 3.0
    @State private var distance: OrbitDistance = .middle
    @State private var note = ""

    var body: some View {
        ZStack {
            AuroraBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    titleInput
                    categoryPicker
                    energyPicker
                    GlassCard {
                        IntensitySlider(intensity: $intensity)
                    }
                    GlassCard {
                        VStack(alignment: .leading, spacing: 14) {
                            SectionLabel("Distance from center")
                            DistanceSelector(selection: $distance)
                        }
                    }
                    noteInput
                    if !canSave {
                        Text("Add a name to enable saving.")
                            .font(OrbitTheme.caption)
                            .foregroundStyle(OrbitTheme.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    saveButton
                }
                .padding(20)
                .padding(.bottom, 28)
            }
        }
        .navigationBarHidden(mode == .tab)
        .toolbar {
            if mode == .modal {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .foregroundStyle(OrbitTheme.textPrimary)
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(mode == .modal ? "New point" : "Add")
                .font(OrbitTheme.largeTitle)
                .foregroundStyle(OrbitTheme.textPrimary)
            Text("Name one thing circling your attention. Keep it light; the orbit will carry the rest.")
                .font(OrbitTheme.body)
                .foregroundStyle(OrbitTheme.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.top, mode == .tab ? 18 : 6)
    }

    private var titleInput: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionLabel("Orbit point")
                TextField("e.g. Product review", text: $title)
                    .font(.system(size: 26, weight: .semibold, design: .rounded))
                    .foregroundStyle(OrbitTheme.textPrimary)
                    .textInputAutocapitalization(.words)
                    .submitLabel(.next)
            }
        }
    }

    private var categoryPicker: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 14) {
                SectionLabel("Type")
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 104), spacing: 8)], alignment: .leading, spacing: 8) {
                    ForEach(OrbitCategory.allCases) { item in
                        Button {
                            category = item
                        } label: {
                            CategoryPill(category: item, isSelected: category == item)
                        }
                        .buttonStyle(PressScaleButtonStyle())
                    }
                }
            }
        }
    }

    private var energyPicker: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 14) {
                SectionLabel("Energy direction")
                VStack(spacing: 10) {
                    ForEach(EnergyType.allCases) { item in
                        Button {
                            energyType = item
                        } label: {
                            EnergyPill(energy: item, isSelected: energyType == item)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .buttonStyle(PressScaleButtonStyle())
                    }
                }
            }
        }
    }

    private var noteInput: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionLabel("One-line note")
                TextField("What made it feel this close?", text: $note, axis: .vertical)
                    .lineLimit(2...4)
                    .font(OrbitTheme.body)
                    .foregroundStyle(OrbitTheme.textPrimary)
            }
        }
    }

    private var saveButton: some View {
        Button {
            save()
        } label: {
            Label("Save to today's orbit", systemImage: "checkmark")
                .font(.system(size: 16, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .foregroundStyle(canSave ? OrbitTheme.background : OrbitTheme.textSecondary)
                .background(
                    Capsule()
                        .fill(canSave ? energyType.color : OrbitTheme.glassSurface)
                        .overlay(Capsule().stroke(OrbitTheme.borderSubtle, lineWidth: 1))
                )
        }
        .disabled(!canSave)
        .buttonStyle(PressScaleButtonStyle())
    }

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func save() {
        let fallbackNote = note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? "No note yet. Just enough signal to place it on the map."
            : note.trimmingCharacters(in: .whitespacesAndNewlines)

        let entry = OrbitEntry(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            category: category,
            energyType: energyType,
            intensity: Int(intensity.rounded()),
            distance: distance,
            note: fallbackNote,
            date: Date()
        )

        store.add(entry)
        reset()

        if mode == .modal {
            dismiss()
        }
        onSaved()
    }

    private func reset() {
        title = ""
        category = .project
        energyType = .positive
        intensity = 3
        distance = .middle
        note = ""
    }
}

#Preview {
    AddEntryView(mode: .tab) {}
        .environmentObject(OrbitStore())
        .preferredColorScheme(.dark)
}
