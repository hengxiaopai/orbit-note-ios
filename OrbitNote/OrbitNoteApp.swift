import SwiftUI

@main
struct OrbitNoteApp: App {
    @StateObject private var store = OrbitStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
                .preferredColorScheme(.dark)
        }
    }
}
