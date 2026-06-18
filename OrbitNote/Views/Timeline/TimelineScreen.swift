import SwiftUI

struct TimelineScreen: View {
    @EnvironmentObject private var store: OrbitStore
    @State private var selectedDay: OrbitDay?

    var body: some View {
        ZStack {
            AuroraBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    header

                    ForEach(store.recentDays) { day in
                        Button {
                            selectedDay = day
                        } label: {
                            MiniOrbitCard(day: day)
                        }
                        .buttonStyle(PressScaleButtonStyle())
                    }
                }
                .padding(20)
                .padding(.top, 18)
                .padding(.bottom, 28)
            }
        }
        .navigationBarHidden(true)
        .sheet(item: $selectedDay) { day in
            NavigationStack {
                DayOrbitDetailView(day: day)
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
            .preferredColorScheme(.dark)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recent 7 days")
                .font(OrbitTheme.caption)
                .foregroundStyle(OrbitTheme.textSecondary)
            Text("Timeline")
                .font(OrbitTheme.largeTitle)
                .foregroundStyle(OrbitTheme.textPrimary)
            Text("A vertical scan of how your center moved across the week.")
                .font(OrbitTheme.body)
                .foregroundStyle(OrbitTheme.textSecondary)
        }
    }
}
