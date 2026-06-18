import SwiftUI

struct OrbitHomeView: View {
    @EnvironmentObject private var store: OrbitStore
    @State private var selectedEntry: OrbitEntry?
    @State private var showingAdd = false

    var body: some View {
        ZStack {
            AuroraBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    header

                    if store.todaysEntries.isEmpty {
                        EmptyState()
                    } else {
                        OrbitCanvas(
                            entries: store.todaysEntries,
                            recentlyAddedID: store.recentlyAddedID
                        ) { entry in
                            selectedEntry = entry
                        }
                        .frame(height: 390)
                        .padding(.vertical, 6)
                    }

                    OrbitSummaryCard(
                        closest: store.closestEntry(in: store.todaysEntries),
                        draining: store.strongestDraining(in: store.todaysEntries),
                        positive: store.strongestPositive(in: store.todaysEntries)
                    )

                    Button {
                        showingAdd = true
                    } label: {
                        Label("Add orbit point", systemImage: "plus")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundStyle(OrbitTheme.background)
                            .background(
                                Capsule()
                                    .fill(OrbitTheme.positive)
                                    .shadow(color: OrbitTheme.positive.opacity(0.22), radius: 18, y: 8)
                            )
                    }
                    .buttonStyle(PressScaleButtonStyle())
                    .padding(.bottom, 24)
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
            }
        }
        .navigationBarHidden(true)
        .sheet(item: $selectedEntry) { entry in
            NavigationStack {
                OrbitDetailView(entry: entry)
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
            .preferredColorScheme(.dark)
        }
        .fullScreenCover(isPresented: $showingAdd) {
            NavigationStack {
                AddEntryView(mode: .modal) {
                    showingAdd = false
                }
            }
            .preferredColorScheme(.dark)
        }
        .onChange(of: store.recentlyAddedID) { _, newValue in
            guard newValue != nil else { return }
            Task {
                try? await Task.sleep(for: .seconds(1.3))
                await MainActor.run {
                    store.clearRecentlyAdded()
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(Date().formatted(.dateTime.weekday(.wide).month(.wide).day()))
                        .font(OrbitTheme.caption)
                        .foregroundStyle(OrbitTheme.textSecondary)
                    Text("Today's Orbit")
                        .font(OrbitTheme.largeTitle)
                        .foregroundStyle(OrbitTheme.textPrimary)
                }
                Spacer()
                Image(systemName: "orbit")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(OrbitTheme.positive)
                    .frame(width: 48, height: 48)
                    .background(Circle().fill(OrbitTheme.glassSurface))
            }

            Text(statusCopy)
                .font(OrbitTheme.body)
                .foregroundStyle(OrbitTheme.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var statusCopy: String {
        let entries = store.todaysEntries
        guard !entries.isEmpty else {
            return "Your field is quiet. Add one point to locate what is circling today."
        }

        let draining = entries.filter { $0.energyType == .draining }.reduce(0) { $0 + $1.intensity }
        let positive = entries.filter { $0.energyType == .positive }.reduce(0) { $0 + $1.intensity }

        if draining > positive + 2 {
            return "Your attention is pulled inward. One heavy point may need more distance tomorrow."
        } else if positive > draining + 2 {
            return "There is a bright cluster today. Protect the thing that gives you energy."
        } else {
            return "Your attention is clustered, but not crowded."
        }
    }
}

#Preview {
    NavigationStack {
        OrbitHomeView()
            .environmentObject(OrbitStore())
    }
    .preferredColorScheme(.dark)
}
