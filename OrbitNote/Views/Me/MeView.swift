import SwiftUI

struct MeView: View {
    @EnvironmentObject private var store: OrbitStore
    @State private var darkModePinned = true
    @State private var showingClearConfirmation = false
    @State private var exportItem: ExportShareItem?
    @State private var permissionStatus: ReminderPermissionStatus = .notRequested
    @AppStorage("orbitNote.reminderEnabled") private var reminderEnabled = false
    @AppStorage("orbitNote.reminderHour") private var reminderHour = 21
    @AppStorage("orbitNote.reminderMinute") private var reminderMinute = 30

    var body: some View {
        ZStack {
            AuroraBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    header
                    themeSection
                    reminderSection
                    privacySection
                    dataSection
                    exportSection
                }
                .padding(20)
                .padding(.top, 18)
                .padding(.bottom, 28)
            }
        }
        .navigationBarHidden(true)
        .sheet(item: $exportItem) { item in
            ShareSheet(activityItems: [item.url])
                .presentationDetents([.medium, .large])
        }
        .task {
            permissionStatus = await ReminderService.permissionStatus()
        }
        .onChange(of: reminderTime) { _, newValue in
            guard reminderEnabled else { return }
            let components = Calendar.current.dateComponents([.hour, .minute], from: newValue)
            reminderHour = components.hour ?? reminderHour
            reminderMinute = components.minute ?? reminderMinute
            Task {
                await scheduleReminder(showSuccess: true)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Local space")
                .font(OrbitTheme.caption)
                .foregroundStyle(OrbitTheme.textSecondary)
            Text("Me")
                .font(OrbitTheme.largeTitle)
                .foregroundStyle(OrbitTheme.textPrimary)
            Text("Orbit Note keeps the first version local, quiet, and private.")
                .font(OrbitTheme.body)
                .foregroundStyle(OrbitTheme.textSecondary)
        }
    }

    private var themeSection: some View {
        SettingsCard(title: "Theme", symbol: "moon.stars") {
            Toggle("Dark mode first", isOn: $darkModePinned)
            Text("The MVP pins the experience to a near-black OLED theme. Light mode can become a softer mirror later.")
                .font(OrbitTheme.caption)
                .foregroundStyle(OrbitTheme.textSecondary)
        }
    }

    private var reminderSection: some View {
        SettingsCard(title: "Reminders", symbol: "bell") {
            VStack(alignment: .leading, spacing: 14) {
                Toggle("Evening orbit reminder", isOn: Binding(
                    get: { reminderEnabled },
                    set: { isEnabled in
                        Task {
                            await setReminderEnabled(isEnabled)
                        }
                    }
                ))

                DatePicker("Reminder time", selection: reminderTimeBinding, displayedComponents: .hourAndMinute)
                    .disabled(!reminderEnabled)
                    .opacity(reminderEnabled ? 1 : 0.48)

                HStack {
                    Text("Permission")
                        .font(OrbitTheme.caption)
                        .foregroundStyle(OrbitTheme.textSecondary)
                    Spacer()
                    Text(permissionStatus.title)
                        .font(OrbitTheme.numeric)
                        .foregroundStyle(permissionStatus == .allowed ? OrbitTheme.positive : OrbitTheme.textSecondary)
                }

                Text(reminderHelpText)
                    .font(OrbitTheme.caption)
                    .foregroundStyle(OrbitTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var reminderTime: Date {
        var components = DateComponents()
        components.hour = reminderHour
        components.minute = reminderMinute
        return Calendar.current.date(from: components) ?? Date()
    }

    private var reminderTimeBinding: Binding<Date> {
        Binding(
            get: { reminderTime },
            set: { newValue in
                let components = Calendar.current.dateComponents([.hour, .minute], from: newValue)
                reminderHour = components.hour ?? reminderHour
                reminderMinute = components.minute ?? reminderMinute
            }
        )
    }

    private var reminderHelpText: String {
        switch permissionStatus {
        case .notRequested:
            return "Turn on the reminder when you are ready. Orbit Note will ask for permission then."
        case .allowed:
            return "One quiet reminder is scheduled each evening. No streaks, no pressure."
        case .notAllowed:
            return "Notifications are disabled. You can enable them in Settings."
        }
    }

    @MainActor
    private func setReminderEnabled(_ isEnabled: Bool) async {
        if isEnabled {
            var status = await ReminderService.permissionStatus()
            if status == .notRequested {
                status = await ReminderService.requestPermission()
            }
            permissionStatus = status

            guard status == .allowed else {
                reminderEnabled = false
                ReminderService.cancelReminder()
                store.publishError("Notifications are disabled. You can enable them in Settings.")
                return
            }

            reminderEnabled = true
            await scheduleReminder(showSuccess: true)
        } else {
            reminderEnabled = false
            ReminderService.cancelReminder()
            store.publishSuccess("Evening reminder turned off")
        }
    }

    @MainActor
    private func scheduleReminder(showSuccess: Bool) async {
        do {
            try await ReminderService.scheduleDailyReminder(hour: reminderHour, minute: reminderMinute)
            if showSuccess {
                store.publishSuccess("Evening reminder scheduled")
            }
        } catch {
            reminderEnabled = false
            store.publishError("Could not schedule reminder")
        }
    }

    private var privacySection: some View {
        SettingsCard(title: "Privacy", symbol: "lock.shield") {
            Text("Orbit points are stored locally with SwiftData. There is no account, login, sync, or external backend in v0.2.")
                .font(OrbitTheme.body)
                .foregroundStyle(OrbitTheme.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var dataSection: some View {
        SettingsCard(title: "Local data", symbol: "internaldrive") {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("\(store.entries.count) saved orbit points")
                        .font(OrbitTheme.body)
                    Spacer()
                    Text("Local")
                        .font(OrbitTheme.numeric)
                        .foregroundStyle(OrbitTheme.positive)
                }

                Button(role: .destructive) {
                    showingClearConfirmation = true
                } label: {
                    Label("Clear local data", systemImage: "trash")
                        .font(.system(size: 15, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .foregroundStyle(OrbitTheme.draining)
                        .background(Capsule().fill(OrbitTheme.draining.opacity(0.12)))
                }
                .buttonStyle(PressScaleButtonStyle())

                if store.entries.isEmpty {
                    Button {
                        store.restoreSampleData()
                    } label: {
                        Label("Restore sample data", systemImage: "sparkles")
                            .font(.system(size: 15, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .foregroundStyle(OrbitTheme.background)
                            .background(Capsule().fill(OrbitTheme.positive))
                    }
                    .buttonStyle(PressScaleButtonStyle())
                }

                Text("Clearing data leaves the app empty. You can restore the sample orbit after clearing.")
                    .font(OrbitTheme.caption)
                    .foregroundStyle(OrbitTheme.textSecondary)
            }
        }
        .alert("Clear all local data?", isPresented: $showingClearConfirmation) {
            Button("Clear", role: .destructive) {
                store.clearLocalData(reseed: false)
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This removes all saved orbit points from this device.")
        }
    }

    private var exportSection: some View {
        SettingsCard(title: "Export", symbol: "square.and.arrow.up") {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Export local data")
                        .font(OrbitTheme.body)
                    Spacer()
                    Text(store.entries.isEmpty ? "Empty" : "\(store.entries.count)")
                        .font(OrbitTheme.numeric)
                        .foregroundStyle(store.entries.isEmpty ? OrbitTheme.textSecondary : OrbitTheme.positive)
                }

                HStack(spacing: 10) {
                    exportButton(format: .json)
                    exportButton(format: .csv)
                }

                Text(store.entries.isEmpty ? "Add orbit points before exporting." : "Exports include title, category, energy, intensity, distance, note, date, and createdAt.")
                    .font(OrbitTheme.caption)
                    .foregroundStyle(OrbitTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func exportButton(format: OrbitExportFormat) -> some View {
        Button {
            export(format: format)
        } label: {
            Label(format.title, systemImage: "square.and.arrow.up")
                .font(.system(size: 14, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 11)
                .foregroundStyle(store.entries.isEmpty ? OrbitTheme.textSecondary : OrbitTheme.background)
                .background(
                    Capsule()
                        .fill(store.entries.isEmpty ? OrbitTheme.glassSurface : OrbitTheme.positive)
                        .overlay(Capsule().stroke(OrbitTheme.borderSubtle, lineWidth: 1))
                )
        }
        .disabled(store.entries.isEmpty)
        .buttonStyle(PressScaleButtonStyle())
    }

    private func export(format: OrbitExportFormat) {
        do {
            exportItem = ExportShareItem(url: try OrbitExportService.makeExportFile(entries: store.entries, format: format))
            store.publishSuccess("\(format.title) export ready")
        } catch {
            store.publishError(error.localizedDescription)
        }
    }
}

private struct ExportShareItem: Identifiable {
    let url: URL

    var id: String { url.absoluteString }
}

private struct SettingsCard<Content: View>: View {
    let title: String
    let symbol: String
    @ViewBuilder var content: Content

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 14) {
                Label(title, systemImage: symbol)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(OrbitTheme.textPrimary)

                content
                    .tint(OrbitTheme.positive)
                    .foregroundStyle(OrbitTheme.textPrimary)
            }
        }
    }
}
