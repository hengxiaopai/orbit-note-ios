import Foundation

final class OrbitStore: ObservableObject {
    @Published private(set) var entries: [OrbitEntry]
    @Published var recentlyAddedID: OrbitEntry.ID?

    init(entries: [OrbitEntry] = OrbitMockData.entries) {
        self.entries = entries
    }

    var today: Date {
        Calendar.current.startOfDay(for: Date())
    }

    var todaysEntries: [OrbitEntry] {
        entries(for: today)
    }

    var recentDays: [OrbitDay] {
        (0..<7).compactMap { offset in
            guard let date = Calendar.current.date(byAdding: .day, value: -offset, to: today) else {
                return nil
            }
            return OrbitDay(date: date, entries: entries(for: date))
        }
    }

    func entries(for date: Date) -> [OrbitEntry] {
        let day = Calendar.current.startOfDay(for: date)
        return entries
            .filter { Calendar.current.isDate($0.date, inSameDayAs: day) }
            .sorted { $0.createdAt < $1.createdAt }
    }

    func add(_ entry: OrbitEntry) {
        entries.append(entry)
        recentlyAddedID = entry.id
    }

    func clearRecentlyAdded() {
        recentlyAddedID = nil
    }

    func closestEntry(in entries: [OrbitEntry]) -> OrbitEntry? {
        entries.sorted {
            if $0.distance.radiusMultiplier == $1.distance.radiusMultiplier {
                return $0.intensity > $1.intensity
            }
            return $0.distance.radiusMultiplier < $1.distance.radiusMultiplier
        }.first
    }

    func strongestPositive(in entries: [OrbitEntry]) -> OrbitEntry? {
        entries
            .filter { $0.energyType == .positive }
            .max { $0.intensity < $1.intensity }
    }

    func strongestDraining(in entries: [OrbitEntry]) -> OrbitEntry? {
        entries
            .filter { $0.energyType == .draining }
            .max { $0.intensity < $1.intensity }
    }
}

enum OrbitMockData {
    static let entries: [OrbitEntry] = {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        func day(_ offset: Int) -> Date {
            calendar.date(byAdding: .day, value: -offset, to: today) ?? today
        }

        func time(_ offset: Int, hour: Int, minute: Int) -> Date {
            calendar.date(bySettingHour: hour, minute: minute, second: 0, of: day(offset)) ?? day(offset)
        }

        return [
            OrbitEntry(title: "Product review", category: .work, energyType: .draining, intensity: 4, distance: .near, note: "The unresolved scope kept pulling attention back all afternoon.", date: day(0), createdAt: time(0, hour: 9, minute: 20)),
            OrbitEntry(title: "Morning run", category: .body, energyType: .positive, intensity: 4, distance: .middle, note: "Twenty quiet minutes before messages started arriving.", date: day(0), createdAt: time(0, hour: 7, minute: 40)),
            OrbitEntry(title: "Mia's launch draft", category: .project, energyType: .positive, intensity: 3, distance: .middle, note: "The concept finally feels like it has a spine.", date: day(0), createdAt: time(0, hour: 14, minute: 10)),
            OrbitEntry(title: "Rent renewal", category: .money, energyType: .draining, intensity: 3, distance: .far, note: "Not urgent yet, but the number is sitting in the corner.", date: day(0), createdAt: time(0, hour: 18, minute: 25)),
            OrbitEntry(title: "Call with mom", category: .relationship, energyType: .neutral, intensity: 2, distance: .middle, note: "Warm, but I was too distracted to be fully there.", date: day(0), createdAt: time(0, hour: 21, minute: 5)),

            OrbitEntry(title: "Client revision loop", category: .work, energyType: .draining, intensity: 5, distance: .near, note: "The third round was more about confidence than content.", date: day(1), createdAt: time(1, hour: 11, minute: 30)),
            OrbitEntry(title: "Sketching icons", category: .creation, energyType: .positive, intensity: 3, distance: .middle, note: "Small shapes, surprisingly calming.", date: day(1), createdAt: time(1, hour: 16, minute: 0)),
            OrbitEntry(title: "Late coffee", category: .body, energyType: .draining, intensity: 2, distance: .far, note: "It solved the afternoon and borrowed from the night.", date: day(1), createdAt: time(1, hour: 17, minute: 15)),

            OrbitEntry(title: "Team sync", category: .work, energyType: .neutral, intensity: 3, distance: .middle, note: "Useful, but too many threads opened at once.", date: day(2), createdAt: time(2, hour: 10, minute: 0)),
            OrbitEntry(title: "Portfolio note", category: .creation, energyType: .positive, intensity: 5, distance: .near, note: "A sentence I want to keep building around.", date: day(2), createdAt: time(2, hour: 22, minute: 10)),
            OrbitEntry(title: "Unread invoices", category: .money, energyType: .draining, intensity: 3, distance: .middle, note: "Nothing broken, just unfinished admin weight.", date: day(2), createdAt: time(2, hour: 15, minute: 45)),
            OrbitEntry(title: "Neck stiffness", category: .body, energyType: .draining, intensity: 2, distance: .far, note: "The body quietly voted against another long desk day.", date: day(2), createdAt: time(2, hour: 20, minute: 30)),

            OrbitEntry(title: "Dinner with Jun", category: .relationship, energyType: .positive, intensity: 4, distance: .near, note: "The first conversation this week that felt uncompressed.", date: day(3), createdAt: time(3, hour: 19, minute: 40)),
            OrbitEntry(title: "Roadmap edits", category: .project, energyType: .neutral, intensity: 3, distance: .middle, note: "Moved pieces around without making a final decision.", date: day(3), createdAt: time(3, hour: 13, minute: 25)),
            OrbitEntry(title: "Sleep debt", category: .body, energyType: .draining, intensity: 4, distance: .near, note: "Everything felt one step louder than usual.", date: day(3), createdAt: time(3, hour: 8, minute: 50)),

            OrbitEntry(title: "New prototype idea", category: .creation, energyType: .positive, intensity: 5, distance: .near, note: "It kept returning between meetings, in a good way.", date: day(4), createdAt: time(4, hour: 12, minute: 35)),
            OrbitEntry(title: "Contract wording", category: .money, energyType: .draining, intensity: 3, distance: .middle, note: "Tiny clauses with a large shadow.", date: day(4), createdAt: time(4, hour: 16, minute: 10)),
            OrbitEntry(title: "Laundry mountain", category: .unknown, energyType: .neutral, intensity: 1, distance: .far, note: "Domestic background noise.", date: day(4), createdAt: time(4, hour: 21, minute: 0)),
            OrbitEntry(title: "Design critique", category: .work, energyType: .positive, intensity: 3, distance: .middle, note: "Sharp feedback, but it clarified the next move.", date: day(4), createdAt: time(4, hour: 10, minute: 20)),

            OrbitEntry(title: "Budget spreadsheet", category: .money, energyType: .draining, intensity: 4, distance: .near, note: "The numbers were manageable, the avoidance was not.", date: day(5), createdAt: time(5, hour: 9, minute: 15)),
            OrbitEntry(title: "Long walk", category: .body, energyType: .positive, intensity: 4, distance: .middle, note: "The city finally felt like a tempo instead of a task.", date: day(5), createdAt: time(5, hour: 18, minute: 5)),
            OrbitEntry(title: "Message from Leo", category: .relationship, energyType: .neutral, intensity: 2, distance: .far, note: "A thread I do not need to answer tonight.", date: day(5), createdAt: time(5, hour: 20, minute: 45)),
            OrbitEntry(title: "Feature naming", category: .project, energyType: .positive, intensity: 2, distance: .middle, note: "Not solved, but the shape is friendlier now.", date: day(5), createdAt: time(5, hour: 14, minute: 50)),

            OrbitEntry(title: "Family plans", category: .relationship, energyType: .draining, intensity: 3, distance: .middle, note: "Everyone means well, and it still takes space.", date: day(6), createdAt: time(6, hour: 11, minute: 5)),
            OrbitEntry(title: "Quiet reading", category: .creation, energyType: .positive, intensity: 3, distance: .far, note: "A small reserve of language for later.", date: day(6), createdAt: time(6, hour: 22, minute: 20)),
            OrbitEntry(title: "Launch checklist", category: .project, energyType: .neutral, intensity: 4, distance: .near, note: "Close enough to matter, calm enough to plan.", date: day(6), createdAt: time(6, hour: 15, minute: 30))
        ]
    }()
}
