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
    @AppStorage("orbitNote.didFinishOnboarding.v1") private var didFinishOnboarding = false
    @State private var selectedTab: AppTab = .orbit

    var body: some View {
        ZStack(alignment: .top) {
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

            if let feedback = store.feedback {
                ToastBanner(feedback: feedback)
                    .padding(.top, 12)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .tint(OrbitTheme.positive)
        .animation(.spring(response: 0.34, dampingFraction: 0.86), value: store.feedback)
        .onAppear {
            GlassTabBar.configure()
        }
        .task {
            await store.configure(modelContext: modelContext)
        }
        .onChange(of: store.feedback) { _, newValue in
            guard let current = newValue else { return }
            Task {
                try? await Task.sleep(for: .seconds(2.2))
                await MainActor.run {
                    if store.feedback == current {
                        store.feedback = nil
                    }
                }
            }
        }
        .fullScreenCover(isPresented: Binding(
            get: { !didFinishOnboarding },
            set: { didFinishOnboarding = !$0 }
        )) {
            OnboardingView {
                didFinishOnboarding = true
            }
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    RootView()
        .environmentObject(OrbitStore(entries: OrbitSeedData.entries))
        .modelContainer(for: OrbitEntryModel.self, inMemory: true)
        .preferredColorScheme(.dark)
}
