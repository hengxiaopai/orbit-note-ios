import XCTest
@testable import OrbitNote

final class OrbitStoreInsightAdapterTests: XCTestCase {
    @MainActor
    func testAdapterReturnsEngineInsightForCurrentEntries() {
        let date = fixedDate(day: 18)
        let generatedAt = fixedDate(day: 18, hour: 21)
        let entries = [
            entry("Morning walk", energy: .positive, intensity: 4, distance: .middle, date: date),
            entry("Budget review", energy: .draining, intensity: 5, distance: .near, date: date, minute: 10),
            entry("Yesterday inbox", energy: .draining, intensity: 5, distance: .near, date: fixedDate(day: 17))
        ]
        let store = OrbitStore(entries: entries)

        let adapterInsight = store.makeTodayInsight(on: date, generatedAt: generatedAt)
        let engineInsight = TodayOrbitInsightEngine.makeInsight(
            entries: entries,
            date: date,
            generatedAt: generatedAt
        )

        XCTAssertEqual(adapterInsight, engineInsight)
        XCTAssertEqual(adapterInsight.entryCount, 2)
        XCTAssertEqual(adapterInsight.focusTitle, "Budget review")
    }

    @MainActor
    func testAdapterIsStableForEmptyStore() {
        let date = fixedDate(day: 18)
        let generatedAt = fixedDate(day: 18, hour: 22)
        let store = OrbitStore(entries: [])

        let insight = store.makeTodayInsight(on: date, generatedAt: generatedAt)

        XCTAssertEqual(insight.generatedAt, generatedAt)
        XCTAssertEqual(insight.entryCount, 0)
        XCTAssertEqual(insight.headline, "No orbit yet")
        XCTAssertNil(insight.focusTitle)
        XCTAssertNil(insight.positiveTitle)
        XCTAssertNil(insight.drainingTitle)
    }

    private func entry(
        _ title: String,
        energy: EnergyType,
        intensity: Int,
        distance: OrbitDistance,
        date: Date,
        minute: Int = 0
    ) -> OrbitEntry {
        OrbitEntry(
            id: UUID(uuidString: "10000000-0000-0000-0000-\(String(format: "%012d", minute + intensity))")!,
            title: title,
            category: .project,
            energyType: energy,
            intensity: intensity,
            distance: distance,
            note: "Adapter test note",
            date: date,
            createdAt: fixedDate(day: Calendar.current.component(.day, from: date), minute: minute)
        )
    }

    private func fixedDate(day: Int, hour: Int = 9, minute: Int = 0) -> Date {
        var components = DateComponents()
        components.calendar = Calendar(identifier: .gregorian)
        components.timeZone = TimeZone(secondsFromGMT: 0)
        components.year = 2026
        components.month = 6
        components.day = day
        components.hour = hour
        components.minute = minute
        return components.date!
    }
}
