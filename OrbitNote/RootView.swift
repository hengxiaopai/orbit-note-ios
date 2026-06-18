import SwiftUI

enum AppTab: Hashable {
    case orbit
    case add
    case timeline
    case me
}

struct RootView: View {
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
    }
}

#Preview {
    RootView()
        .environmentObject(OrbitStore())
        .preferredColorScheme(.dark)
}
