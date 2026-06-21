import Foundation

enum TodayOrbitInsightEngine {
    static func makeInsight(
        entries: [OrbitEntry],
        date: Date = Date(),
        generatedAt: Date = Date()
    ) -> TodayOrbitInsight {
        let day = Calendar.current.startOfDay(for: date)
        let todaysEntries = entries
            .filter { Calendar.current.isDate($0.date, inSameDayAs: day) }
            .sorted { $0.createdAt < $1.createdAt }

        guard !todaysEntries.isEmpty else {
            return emptyInsight(for: day, generatedAt: generatedAt)
        }

        let focus = closestEntry(in: todaysEntries)
        let positive = strongestPositive(in: todaysEntries)
        let draining = strongestDraining(in: todaysEntries)
        let dominant = dominantEnergy(in: todaysEntries)

        return TodayOrbitInsight(
            generatedAt: generatedAt,
            date: day,
            entryCount: todaysEntries.count,
            headline: headline(for: dominant, count: todaysEntries.count),
            summary: summary(
                count: todaysEntries.count,
                dominant: dominant,
                focus: focus,
                positive: positive,
                draining: draining
            ),
            focusTitle: focus?.title,
            positiveTitle: positive?.title,
            drainingTitle: draining?.title,
            suggestedPrompt: suggestedPrompt(for: dominant, focus: focus, positive: positive, draining: draining)
        )
    }

    private static func emptyInsight(for day: Date, generatedAt: Date) -> TodayOrbitInsight {
        TodayOrbitInsight(
            generatedAt: generatedAt,
            date: day,
            entryCount: 0,
            headline: "No orbit yet",
            summary: "There are no orbit points for today yet. A single point is enough to begin seeing what stayed close.",
            focusTitle: nil,
            positiveTitle: nil,
            drainingTitle: nil,
            suggestedPrompt: "What has taken the most attention today?"
        )
    }

    private static func headline(for dominant: EnergyType, count: Int) -> String {
        switch dominant {
        case .positive:
            return count > 2 ? "Energy is gathering" : "A light orbit is forming"
        case .draining:
            return count > 2 ? "Attention feels heavy" : "Something is pulling close"
        case .neutral:
            return count > 2 ? "Your orbit is steady" : "A quiet orbit is forming"
        }
    }

    private static func summary(
        count: Int,
        dominant: EnergyType,
        focus: OrbitEntry?,
        positive: OrbitEntry?,
        draining: OrbitEntry?
    ) -> String {
        let countText = count == 1 ? "1 orbit point" : "\(count) orbit points"
        let focusText = focus.map { "\($0.title) is closest to your attention" } ?? "Your attention is still spreading out"

        switch dominant {
        case .positive:
            let supportText = positive.map { ", with \($0.title) giving the clearest lift" } ?? ""
            return "Today has \(countText). \(focusText)\(supportText)."
        case .draining:
            let drainText = draining.map { ", and \($0.title) carries the strongest weight" } ?? ""
            return "Today has \(countText). \(focusText)\(drainText)."
        case .neutral:
            return "Today has \(countText). \(focusText), while the overall energy stays balanced."
        }
    }

    private static func suggestedPrompt(
        for dominant: EnergyType,
        focus: OrbitEntry?,
        positive: OrbitEntry?,
        draining: OrbitEntry?
    ) -> String {
        switch dominant {
        case .positive:
            if let positive {
                return "What small space can you keep for \(positive.title) tomorrow?"
            }
            return "What gave you a little more energy than expected?"
        case .draining:
            if let draining {
                return "What would help place \(draining.title) a little farther away tomorrow?"
            }
            return "What felt closer than it needed to be today?"
        case .neutral:
            if let focus {
                return "Is \(focus.title) still worth keeping this close tomorrow?"
            }
            return "What do you want to observe without rushing to fix it?"
        }
    }

    private static func dominantEnergy(in entries: [OrbitEntry]) -> EnergyType {
        let totals = Dictionary(grouping: entries, by: \.energyType)
            .mapValues { $0.reduce(0) { $0 + $1.intensity } }
        return totals.max { $0.value < $1.value }?.key ?? .neutral
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
