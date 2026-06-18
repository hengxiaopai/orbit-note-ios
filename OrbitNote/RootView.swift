import SwiftData
import SwiftUI

enum AppTab: Hashable {
    case orbit
    case add
    case timeline
    case me
}

struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var store: OrbitStore
    @State private var selectedTab: AppTab = .orbit

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                OrbitHomeView()
            }
            .tabItem {
                Label("Orbit", systemImage: "orbit")
            }
            .tag(AppTab.orbit)

            NavigationStack {
                AddEntryView(mode: .tab) {
                    selectedTab = .orbit
                }
            }
            .tabItem {
                Label("Add", systemImage: "plus.circle")
            }
            .tag(AppTab.add)

            NavigationStack {
                TimelineScreen()
            }
            .tabItem {
                Label("Timeline", systemImage: "timeline.selection")
            }
            .tag(AppTab.timeline)

            NavigationStack {
                MeView()
            }
            .tabItem {
                Label("Me", systemImage: "person.crop.circle")
            }
            .tag(AppTab.me)
        }
        .tint(OrbitTheme.positive)
        .onAppear {
            GlassTabBar.configure()
        }
        .task {
            store.configure(modelContext: modelContext)
        }
    }
}

#Preview {
    RootView()
        .environmentObject(OrbitStore(entries: OrbitSeedData.entries))
        .modelContainer(for: OrbitEntryModel.self, inMemory: true)
        .preferredColorScheme(.dark)
}
