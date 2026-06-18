import Foundation

enum OrbitWidgetSnapshotReader {
    private static let appGroupIdentifier = "group.com.codex.orbitnote"
    private static let fileName = "OrbitWidgetSnapshot.json"

    static func read() -> OrbitWidgetSnapshot? {
        guard let url = snapshotURL(),
              FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(OrbitWidgetSnapshot.self, from: data)
        } catch {
            return nil
        }
    }

    private static func snapshotURL() -> URL? {
        FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: appGroupIdentifier)?
            .appendingPathComponent(fileName)
    }
}
