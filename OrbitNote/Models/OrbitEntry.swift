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
        case .relationship:
            return "Relationship"
        case .work:
            return "Work"
        case .project:
            return "Project"
        case .body:
            return "Body"
        case .creation:
            return "Creation"
        case .money:
            return "Money"
        case .unknown:
            return "Unknown"
        }
    }

    var symbol: String {
        switch self {
        case .relationship:
            return "person.2"
        case .work:
            return "briefcase"
        case .project:
            return "square.stack.3d.up"
        case .body:
            return "figure.mind.and.body"
        case .creation:
            return "sparkles"
        case .money:
            return "creditcard"
        case .unknown:
            return "questionmark.circle"
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
        case .positive:
            return "Gives energy"
        case .draining:
            return "Drains me"
        case .neutral:
            return "Neutral"
        }
    }

    var shortTitle: String {
        switch self {
        case .positive:
            return "Positive"
        case .draining:
            return "Draining"
        case .neutral:
            return "Neutral"
        }
    }

    var color: Color {
        switch self {
        case .positive:
            return OrbitTheme.positive
        case .draining:
            return OrbitTheme.draining
        case .neutral:
            return OrbitTheme.neutral
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
        case .near:
            return "Near"
        case .middle:
            return "Middle"
        case .far:
            return "Far"
        }
    }

    var radiusMultiplier: CGFloat {
        switch self {
        case .near:
            return 0.28
        case .middle:
            return 0.52
        case .far:
            return 0.78
        }
    }

    var summary: String {
        switch self {
        case .near:
            return "occupies attention"
        case .middle:
            return "stays present"
        case .far:
            return "passes at the edge"
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
