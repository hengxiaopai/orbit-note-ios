import Foundation

struct OrbitWidgetSnapshot: Codable, Equatable {
    var generatedAt: Date
    var date: Date
    var entryCount: Int
    var dominantEnergy: String
    var dominantEnergyLabel: String
    var dominantEnergyColorName: String
    var closestTitle: String?
    var strongestPositiveTitle: String?
    var strongestDrainingTitle: String?
    var latestEntryTitle: String?
}
