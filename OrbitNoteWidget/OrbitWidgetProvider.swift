import Foundation
import WidgetKit

struct OrbitWidgetEntry: TimelineEntry {
    let date: Date
    let snapshot: OrbitWidgetSnapshot?
}

struct OrbitWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> OrbitWidgetEntry {
        OrbitWidgetEntry(date: Date(), snapshot: .placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (OrbitWidgetEntry) -> Void) {
        completion(OrbitWidgetEntry(date: Date(), snapshot: OrbitWidgetSnapshotReader.read() ?? .placeholder))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<OrbitWidgetEntry>) -> Void) {
        let entry = OrbitWidgetEntry(date: Date(), snapshot: OrbitWidgetSnapshotReader.read())
        let nextRefresh = Calendar.current.date(byAdding: .minute, value: 45, to: Date()) ?? Date().addingTimeInterval(2700)
        completion(Timeline(entries: [entry], policy: .after(nextRefresh)))
    }
}

private extension OrbitWidgetSnapshot {
    static var placeholder: OrbitWidgetSnapshot {
        OrbitWidgetSnapshot(
            generatedAt: Date(),
            date: Date(),
            entryCount: 3,
            dominantEnergy: "positive",
            dominantEnergyLabel: "Positive",
            dominantEnergyColorName: "positive",
            closestTitle: "Launch review",
            strongestPositiveTitle: "Quiet writing hour",
            strongestDrainingTitle: "Inbox cleanup",
            latestEntryTitle: "Evening walk"
        )
    }
}
