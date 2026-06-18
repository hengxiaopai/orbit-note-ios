import SwiftUI

enum AddEntryMode {
    case tab
    case modal
}

struct AddEntryView: View {
    @EnvironmentObject private var store: OrbitStore
    @Environment(\.dismiss) private var dismiss

    let mode: AddEntryMode
    private let editingEntry: OrbitEntry?
    var onSaved: () -> Void

    @State private var title: String
    @State private var category: OrbitCategory
    @State private var energyType: EnergyType
    @State private var intensity: Double
    @State private var distance: OrbitDistance
    @State private var note: String

    init(mode: AddEntryMode, editingEntry: OrbitEntry? = nil, onSaved: @escaping () -> Void) {
        self.mode = mode
        self.editingEntry = editingEntry
        self.onSaved = onSaved
        _title = State(initialValue: editingEntry?.title ?? "")
        _category = State(initialValue: editingEntry?.category ?? .project)
        _energyType = State(initialValue: editingEntry?.energyType ?? .positive)
        _intensity = State(initialValue: Double(editingEntry?.intensity ?? 3))
        _distance = State(initialValue: editingEntry?.distance ?? .middle)
        _note = State(initialValue: editingEntry?.note ?? "")
    }

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
            Text(headerTitle)
                .font(OrbitTheme.largeTitle)
                .foregroundStyle(OrbitTheme.textPrimary)
            Text(headerCopy)
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
            Label(editingEntry == nil ? "Save to today's orbit" : "Save changes", systemImage: "checkmark")
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

    private var headerTitle: String {
        if editingEntry != nil {
            return "Edit point"
        }
        return mode == .modal ? "New point" : "Add"
    }

    private var headerCopy: String {
        if editingEntry != nil {
            return "Adjust its distance, energy, or note without turning it into a task."
        }
        return "Name one thing circling your attention. Keep it light; the orbit will carry the rest."
    }

    private func save() {
        let fallbackNote = note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? "No note yet. Just enough signal to place it on the map."
            : note.trimmingCharacters(in: .whitespacesAndNewlines)

        let entry = OrbitEntry(
            id: editingEntry?.id ?? UUID(),
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            category: category,
            energyType: energyType,
            intensity: Int(intensity.rounded()),
            distance: distance,
            note: fallbackNote,
            date: editingEntry?.date ?? Date(),
            createdAt: editingEntry?.createdAt ?? Date()
        )

        let didSave: Bool
        if editingEntry == nil {
            didSave = store.add(entry)
        } else {
            didSave = store.update(entry)
        }

        guard didSave else {
            return
        }
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
