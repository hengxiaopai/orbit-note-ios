import XCTest
@testable import OrbitNote

final class TodayOrbitInsightEngineTests: XCTestCase {
    func testEmptyInputReturnsStableEmptyInsight() {
        let date = fixedDate(day: 18)
        let generatedAt = fixedDate(day: 18, hour: 21)

        let insight = TodayOrbitInsightEngine.makeInsight(
            entries: [],
            date: date,
            generatedAt: generatedAt
        )

        XCTAssertEqual(insight.generatedAt, generatedAt)
        XCTAssertEqual(insight.date, Calendar.current.startOfDay(for: date))
        XCTAssertEqual(insight.entryCount, 0)
        XCTAssertFalse(insight.headline.isEmpty)
        XCTAssertFalse(insight.summary.isEmpty)
        XCTAssertFalse(insight.suggestedPrompt.isEmpty)
        XCTAssertNil(insight.focusTitle)
        XCTAssertNil(insight.positiveTitle)
        XCTAssertNil(insight.drainingTitle)
    }

    func testOnlyCountsEntriesFromRequestedDay() {
        let today = fixedDate(day: 18)
        let yesterday = fixedDate(day: 17)

        let entries = [
            entry("Yesterday pressure", energy: .draining, intensity: 5, distance: .near, date: yesterday),
            entry("Morning walk", energy: .positive, intensity: 3, distance: .middle, date: today),
            entry("Launch review", energy: .draining, intensity: 4, distance: .near, date: today)
        ]

        let insight = TodayOrbitInsightEngine.makeInsight(
            entries: entries,
            date: today,
            generatedAt: fixedDate(day: 18, hour: 22)
        )

        XCTAssertEqual(insight.entryCount, 2)
        XCTAssertEqual(insight.focusTitle, "Launch review")
        XCTAssertEqual(insight.positiveTitle, "Morning walk")
        XCTAssertEqual(insight.drainingTitle, "Launch review")
        XCTAssertFalse(insight.summary.contains("Yesterday pressure"))
    }

    func testSelectsFocusPositiveAndDrainingDeterministically() {
        let date = fixedDate(day: 18)
        let entries = [
            entry("Far inspiration", energy: .positive, intensity: 5, distance: .far, date: date, minute: 5),
            entry("Close admin", energy: .neutral, intensity: 2, distance: .near, date: date, minute: 10),
            entry("Close deadline", energy: .draining, intensity: 5, distance: .near, date: date, minute: 15),
            entry("Studio time", energy: .positive, intensity: 4, distance: .middle, date: date, minute: 20),
            entry("Inbox cleanup", energy: .draining, intensity: 3, distance: .middle, date: date, minute: 25)
        ]

        let insight = TodayOrbitInsightEngine.makeInsight(
            entries: Array(entries.reversed()),
            date: date,
            generatedAt: fixedDate(day: 18, hour: 23)
        )

        XCTAssertEqual(insight.entryCount, 5)
        XCTAssertEqual(insight.focusTitle, "Close deadline")
        XCTAssertEqual(insight.positiveTitle, "Far inspiration")
        XCTAssertEqual(insight.drainingTitle, "Close deadline")
        XCTAssertEqual(insight.headline, "Energy is gathering")
        XCTAssertTrue(insight.summary.contains("Close deadline is closest"))
        XCTAssertTrue(insight.summary.contains("Far inspiration"))
        XCTAssertTrue(insight.suggestedPrompt.contains("Far inspiration"))
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
            id: UUID(uuidString: "00000000-0000-0000-0000-\(String(format: "%012d", minute + intensity))")!,
            title: title,
            category: .project,
            energyType: energy,
            intensity: intensity,
            distance: distance,
            note: "Test note",
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
