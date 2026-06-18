import SwiftUI

struct OrbitEntry: Identifiable, Hashable {
    let id: UUID
    var title: String
    var category: OrbitCategory
    var energyType: EnergyType
    var intensity: Int
    var distance: OrbitDistance
    var note: String
    var date: Date
    var createdAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        category: OrbitCategory,
        energyType: EnergyType,
        intensity: Int,
        distance: OrbitDistance,
        note: String,
        date: Date,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.energyType = energyType
        self.intensity = min(max(intensity, 1), 5)
        self.distance = distance
        self.note = note
        self.date = Calendar.current.startOfDay(for: date)
        self.createdAt = createdAt
    }
}

enum OrbitCategory: String, CaseIterable, Identifiable, Hashable {
    case relationship
    case work
    case project
    case body
    case creation
    case money
    case unknown

    var id: String { rawValue }

    var title: String {
        switch self {
        case .relationship: "Relationship"
        case .work: "Work"
        case .project: "Project"
        case .body: "Body"
        case .creation: "Creation"
        case .money: "Money"
        case .unknown: "Unknown"
        }
    }

    var symbol: String {
        switch self {
        case .relationship: "person.2"
        case .work: "briefcase"
        case .project: "square.stack.3d.up"
        case .body: "figure.mind.and.body"
        case .creation: "sparkles"
        case .money: "creditcard"
        case .unknown: "questionmark.circle"
        }
    }
}

enum EnergyType: String, CaseIterable, Identifiable, Hashable {
    case positive
    case draining
    case neutral

    var id: String { rawValue }

    var title: String {
        switch self {
        case .positive: "Gives energy"
        case .draining: "Drains me"
        case .neutral: "Neutral"
        }
    }

    var shortTitle: String {
        switch self {
        case .positive: "Positive"
        case .draining: "Draining"
        case .neutral: "Neutral"
        }
    }

    var color: Color {
        switch self {
        case .positive: OrbitTheme.positive
        case .draining: OrbitTheme.draining
        case .neutral: OrbitTheme.neutral
        }
    }
}

enum OrbitDistance: String, CaseIterable, Identifiable, Hashable {
    case near
    case middle
    case far

    var id: String { rawValue }

    var title: String {
        switch self {
        case .near: "Near"
        case .middle: "Middle"
        case .far: "Far"
        }
    }

    var radiusMultiplier: CGFloat {
        switch self {
        case .near: 0.25
        case .middle: 0.42
        case .far: 0.58
        }
    }

    var summary: String {
        switch self {
        case .near: "occupies attention"
        case .middle: "stays present"
        case .far: "passes at the edge"
        }
    }
}

struct OrbitDay: Identifiable, Hashable {
    var date: Date
    var entries: [OrbitEntry]

    var id: Date { date }

    var dominantEnergy: EnergyType {
        let totals = Dictionary(grouping: entries, by: \.energyType)
            .mapValues { $0.reduce(0) { $0 + $1.intensity } }
        return totals.max { $0.value < $1.value }?.key ?? .neutral
    }
}
