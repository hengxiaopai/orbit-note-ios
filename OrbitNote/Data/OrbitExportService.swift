import Foundation

enum OrbitExportFormat: String, CaseIterable, Identifiable {
    case json
    case csv

    var id: String { rawValue }

    var title: String {
        switch self {
        case .json:
            return "JSON"
        case .csv:
            return "CSV"
        }
    }

    var fileExtension: String { rawValue }
}

enum OrbitExportError: LocalizedError {
    case emptyData
    case encodingFailed

    var errorDescription: String? {
        switch self {
        case .emptyData:
            return "There is no local orbit data to export."
        case .encodingFailed:
            return "Could not prepare the export file."
        }
    }
}

enum OrbitExportService {
    static func makeExportFile(entries: [OrbitEntry], format: OrbitExportFormat) throws -> URL {
        guard !entries.isEmpty else {
            throw OrbitExportError.emptyData
        }

        let fileName = "orbit-note-export-\(fileDateString()).\(format.fileExtension)"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        switch format {
        case .json:
            let records = entries
                .sorted { $0.createdAt < $1.createdAt }
                .map(OrbitExportRecord.init(entry:))
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let data = try encoder.encode(records)
            try data.write(to: url, options: .atomic)
        case .csv:
            let csv = makeCSV(entries: entries.sorted { $0.createdAt < $1.createdAt })
            guard let data = csv.data(using: .utf8) else {
                throw OrbitExportError.encodingFailed
            }
            try data.write(to: url, options: .atomic)
        }

        return url
    }

    private static func makeCSV(entries: [OrbitEntry]) -> String {
        let header = ["title", "category", "energyType", "intensity", "distance", "note", "date", "createdAt"]
        let rows = entries.map { entry in
            [
                entry.title,
                entry.category.rawValue,
                entry.energyType.rawValue,
                String(entry.intensity),
                entry.distance.rawValue,
                entry.note,
                isoString(from: entry.date),
                isoString(from: entry.createdAt)
            ].map(escapeCSV).joined(separator: ",")
        }

        return ([header.joined(separator: ",")] + rows).joined(separator: "\n")
    }

    private static func escapeCSV(_ value: String) -> String {
        let escaped = value.replacingOccurrences(of: "\"", with: "\"\"")
        if escaped.contains(",") || escaped.contains("\n") || escaped.contains("\"") {
            return "\"\(escaped)\""
        }
        return escaped
    }

    private static func fileDateString() -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }

    static func isoString(from date: Date) -> String {
        ISO8601DateFormatter().string(from: date)
    }
}

private struct OrbitExportRecord: Encodable {
    let title: String
    let category: String
    let energyType: String
    let intensity: Int
    let distance: String
    let note: String
    let date: String
    let createdAt: String

    init(entry: OrbitEntry) {
        title = entry.title
        category = entry.category.rawValue
        energyType = entry.energyType.rawValue
        intensity = entry.intensity
        distance = entry.distance.rawValue
        note = entry.note
        date = OrbitExportService.isoString(from: entry.date)
        createdAt = OrbitExportService.isoString(from: entry.createdAt)
    }
}
