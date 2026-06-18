import SwiftUI

struct MeView: View {
    @State private var darkModePinned = true
    @State private var eveningReminder = true
    @State private var weeklySummary = false

    var body: some View {
        ZStack {
            AuroraBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    header
                    themeSection
                    reminderSection
                    privacySection
                    exportSection
                }
                .padding(20)
                .padding(.top, 18)
                .padding(.bottom, 28)
            }
        }
        .navigationBarHidden(true)
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
            Toggle("Evening orbit check-in", isOn: $eveningReminder)
            Toggle("Weekly imbalance summary", isOn: $weeklySummary)
            Text("Notification wiring is reserved for v0.2.")
                .font(OrbitTheme.caption)
                .foregroundStyle(OrbitTheme.textSecondary)
        }
    }

    private var privacySection: some View {
        SettingsCard(title: "Privacy", symbol: "lock.shield") {
            Text("Mock data is stored in memory only. A production build should use local persistence first, with explicit export and deletion controls.")
                .font(OrbitTheme.body)
                .foregroundStyle(OrbitTheme.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var exportSection: some View {
        SettingsCard(title: "Export", symbol: "square.and.arrow.up") {
            Button {
            } label: {
                HStack {
                    Text("Export records")
                    Spacer()
                    Text("Soon")
                        .font(OrbitTheme.numeric)
                        .foregroundStyle(OrbitTheme.textSecondary)
                }
            }
            .disabled(true)
        }
    }
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
