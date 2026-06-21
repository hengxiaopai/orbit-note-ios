import Foundation

extension OrbitStore {
    @MainActor
    func makeTodayInsight(
        on date: Date = Date(),
        generatedAt: Date = Date()
    ) -> TodayOrbitInsight {
        TodayOrbitInsightEngine.makeInsight(
            entries: entries,
            date: date,
            generatedAt: generatedAt
        )
    }
}
