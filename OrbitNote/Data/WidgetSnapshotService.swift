import Foundation

enum WidgetSnapshotError: LocalizedError {
    case applicationSupportUnavailable

    var errorDescription: String? {
        switch self {
        case .applicationSupportUnavailable:
            return "Could not access Application Support for the widget snapshot."
        }
    }
}

enum WidgetSnapshotService {
    static let fileName = "OrbitWidgetSnapshot.json"

    static func containerURL() throws -> URL {
        let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        guard let url = urls.first else {
            throw WidgetSnapshotError.applicationSupportUnavailable
        }
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }

    static func snapshotURL() throws -> URL {
        try containerURL().appendingPathComponent(fileName)
    }

    static func makeTodaySnapshot(entries: [OrbitEntry], date: Date = Date()) -> OrbitWidgetSnapshot {
        let day = Calendar.current.startOfDay(for: date)
        let todaysEntries = entries
            .filter { Calendar.current.isDate($0.date, inSameDayAs: day) }
            .sorted { $0.createdAt < $1.createdAt }

        let dominantEnergy = dominantEnergy(in: todaysEntries)

        return OrbitWidgetSnapshot(
            generatedAt: Date(),
            date: day,
            entryCount: todaysEntries.count,
            dominantEnergy: dominantEnergy.rawValue,
            dominantEnergyLabel: dominantEnergy.shortTitle,
            dominantEnergyColorName: dominantEnergyColorName(for: dominantEnergy),
            closestTitle: closestEntry(in: todaysEntries)?.title,
            strongestPositiveTitle: strongestPositive(in: todaysEntries)?.title,
            strongestDrainingTitle: strongestDraining(in: todaysEntries)?.title,
            latestEntryTitle: todaysEntries.last?.title
        )
    }

    @discardableResult
    static func writeTodaySnapshot(entries: [OrbitEntry], date: Date = Date()) throws -> OrbitWidgetSnapshot {
        let snapshot = makeTodaySnapshot(entries: entries, date: date)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(snapshot)
        try data.write(to: snapshotURL(), options: .atomic)
        return snapshot
    }

    static func readSnapshot() throws -> OrbitWidgetSnapshot? {
        let url = try snapshotURL()
        guard FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(OrbitWidgetSnapshot.self, from: data)
    }

    static func clearSnapshot() throws {
        let url = try snapshotURL()
        guard FileManager.default.fileExists(atPath: url.path) else {
            return
        }
        try FileManager.default.removeItem(at: url)
    }

    private static func dominantEnergy(in entries: [OrbitEntry]) -> EnergyType {
        let totals = Dictionary(grouping: entries, by: \.energyType)
            .mapValues { $0.reduce(0) { $0 + $1.intensity } }
        return totals.max { $0.value < $1.value }?.key ?? .neutral
    }

    private static func dominantEnergyColorName(for energy: EnergyType) -> String {
        switch energy {
        case .positive:
            return "positive"
        case .draining:
            return "draining"
        case .neutral:
            return "neutral"
        }
    }

    private static func closestEntry(in entries: [OrbitEntry]) -> OrbitEntry? {
        entries.sorted {
            if $0.distance.radiusMultiplier == $1.distance.radiusMultiplier {
                return $0.intensity > $1.intensity
            }
            return $0.distance.radiusMultiplier < $1.distance.radiusMultiplier
        }.first
    }

    private static func strongestPositive(in entries: [OrbitEntry]) -> OrbitEntry? {
        entries
            .filter { $0.energyType == .positive }
            .max { $0.intensity < $1.intensity }
    }

    private static func strongestDraining(in entries: [OrbitEntry]) -> OrbitEntry? {
        entries
            .filter { $0.energyType == .draining }
            .max { $0.intensity < $1.intensity }
    }
}
