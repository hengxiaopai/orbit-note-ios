import Foundation
import SwiftData

@Model
final class OrbitEntryModel {
    @Attribute(.unique) var id: UUID
    var title: String
    var categoryRawValue: String
    var energyTypeRawValue: String
    var intensity: Int
    var distanceRawValue: String
    var note: String
    var date: Date
    var createdAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        categoryRawValue: String,
        energyTypeRawValue: String,
        intensity: Int,
        distanceRawValue: String,
        note: String,
        date: Date,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.categoryRawValue = categoryRawValue
        self.energyTypeRawValue = energyTypeRawValue
        self.intensity = min(max(intensity, 1), 5)
        self.distanceRawValue = distanceRawValue
        self.note = note
        self.date = Calendar.current.startOfDay(for: date)
        self.createdAt = createdAt
    }

    convenience init(entry: OrbitEntry) {
        self.init(
            id: entry.id,
            title: entry.title,
            categoryRawValue: entry.category.rawValue,
            energyTypeRawValue: entry.energyType.rawValue,
            intensity: entry.intensity,
            distanceRawValue: entry.distance.rawValue,
            note: entry.note,
            date: entry.date,
            createdAt: entry.createdAt
        )
    }

    var entry: OrbitEntry {
        OrbitEntry(
            id: id,
            title: title,
            category: OrbitCategory(rawValue: categoryRawValue) ?? .unknown,
            energyType: EnergyType(rawValue: energyTypeRawValue) ?? .neutral,
            intensity: intensity,
            distance: OrbitDistance(rawValue: distanceRawValue) ?? .middle,
            note: note,
            date: date,
            createdAt: createdAt
        )
    }

    func apply(_ entry: OrbitEntry) {
        title = entry.title
        categoryRawValue = entry.category.rawValue
        energyTypeRawValue = entry.energyType.rawValue
        intensity = min(max(entry.intensity, 1), 5)
        distanceRawValue = entry.distance.rawValue
        note = entry.note
        date = Calendar.current.startOfDay(for: entry.date)
        createdAt = entry.createdAt
    }
}
