import Combine
import Foundation
import SwiftData

final class OrbitStore: ObservableObject {
    @Published private(set) var entries: [OrbitEntry]
    @Published var recentlyAddedID: OrbitEntry.ID?
    @Published private(set) var lastErrorMessage: String?
    @Published var feedback: OrbitFeedback?
    @Published private(set) var widgetSnapshot: OrbitWidgetSnapshot?

    private var modelContext: ModelContext?
    private let seedDefaultsKey = "orbitNote.didSeedSampleData.v1"

    init(entries: [OrbitEntry] = []) {
        self.entries = entries
    }

    @MainActor
    var today: Date {
        Calendar.current.startOfDay(for: Date())
    }

    @MainActor
    var todaysEntries: [OrbitEntry] {
        entries(for: today)
    }

    @MainActor
    var recentDays: [OrbitDay] {
        let grouped = Dictionary(grouping: entries, by: { Calendar.current.startOfDay(for: $0.date) })
        let days = grouped
            .map { OrbitDay(date: $0.key, entries: $0.value.sorted { $0.createdAt < $1.createdAt }) }
            .sorted { $0.date > $1.date }

        return Array(days.prefix(7))
    }

    @MainActor
    func configure(modelContext: ModelContext) {
        self.modelContext = modelContext
        seedIfNeeded()
        refresh()
    }

    @MainActor
    func entries(for date: Date) -> [OrbitEntry] {
        let day = Calendar.current.startOfDay(for: date)
        return entries
            .filter { Calendar.current.isDate($0.date, inSameDayAs: day) }
            .sorted { $0.createdAt < $1.createdAt }
    }

    @MainActor
    func entry(id: OrbitEntry.ID) -> OrbitEntry? {
        entries.first { $0.id == id }
    }

    @MainActor
    @discardableResult
    func add(_ entry: OrbitEntry) -> Bool {
        guard let modelContext else {
            entries.append(entry)
            recentlyAddedID = entry.id
            refreshWidgetSnapshot()
            publishSuccess("Orbit point added")
            return true
        }

        modelContext.insert(OrbitEntryModel(entry: entry))
        return saveAndRefresh(recentlyAddedID: entry.id, successMessage: "Orbit point added")
    }

    @MainActor
    @discardableResult
    func update(_ entry: OrbitEntry) -> Bool {
        guard let modelContext else {
            guard let index = entries.firstIndex(where: { $0.id == entry.id }) else {
                publishError("Could not find orbit point")
                return false
            }
            entries[index] = entry
            refreshWidgetSnapshot()
            publishSuccess("Orbit point updated")
            return true
        }

        guard let model = model(for: entry.id) else {
            publishError("Could not find orbit point")
            return false
        }

        model.apply(entry)
        return saveAndRefresh(successMessage: "Orbit point updated")
    }

    @MainActor
    @discardableResult
    func delete(_ entry: OrbitEntry) -> Bool {
        guard let modelContext else {
            entries.removeAll { $0.id == entry.id }
            refreshWidgetSnapshot()
            publishSuccess("Orbit point deleted")
            return true
        }

        guard let model = model(for: entry.id) else {
            publishError("Could not delete orbit point")
            return false
        }

        modelContext.delete(model)
        return saveAndRefresh(successMessage: "Orbit point deleted")
    }

    @MainActor
    func clearLocalData(reseed: Bool = false) {
        guard let modelContext else {
            entries = reseed ? OrbitSeedData.entries : []
            refreshWidgetSnapshot()
            publishSuccess(reseed ? "Sample data restored" : "Local data cleared")
            return
        }

        let descriptor = FetchDescriptor<OrbitEntryModel>()
        do {
            let models = try modelContext.fetch(descriptor)
            models.forEach { modelContext.delete($0) }
            if reseed {
                OrbitSeedData.entries.forEach { modelContext.insert(OrbitEntryModel(entry: $0)) }
                UserDefaults.standard.set(true, forKey: seedDefaultsKey)
            }
            try modelContext.save()
            refresh()
            publishSuccess(reseed ? "Sample data restored" : "Local data cleared")
        } catch {
            lastErrorMessage = "Could not clear local data."
            publishError("Could not clear local data")
        }
    }

    @MainActor
    func restoreSampleData() {
        clearLocalData(reseed: true)
    }

    @MainActor
    func clearRecentlyAdded() {
        recentlyAddedID = nil
    }

    @MainActor
    @discardableResult
    func refreshWidgetSnapshotFromSettings() -> Bool {
        do {
            widgetSnapshot = try WidgetSnapshotService.writeTodaySnapshot(entries: entries)
            publishSuccess("Widget snapshot refreshed")
            return true
        } catch {
            recordWidgetSnapshotFailure()
            publishError("Could not refresh widget snapshot")
            return false
        }
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

    @MainActor
    private func seedIfNeeded() {
        guard let modelContext else {
            return
        }

        let didSeed = UserDefaults.standard.bool(forKey: seedDefaultsKey)
        var descriptor = FetchDescriptor<OrbitEntryModel>()
        descriptor.fetchLimit = 1

        do {
            let existing = try modelContext.fetch(descriptor)
            if !existing.isEmpty {
                UserDefaults.standard.set(true, forKey: seedDefaultsKey)
                return
            }
            guard !didSeed else {
                return
            }
            OrbitSeedData.entries.forEach { modelContext.insert(OrbitEntryModel(entry: $0)) }
            try modelContext.save()
            UserDefaults.standard.set(true, forKey: seedDefaultsKey)
        } catch {
            lastErrorMessage = "Could not seed local data."
            publishError("Could not seed local data")
        }
    }

    @MainActor
    private func refresh() {
        guard let modelContext else {
            entries.sort { $0.createdAt < $1.createdAt }
            return
        }

        let descriptor = FetchDescriptor<OrbitEntryModel>(
            sortBy: [SortDescriptor(\.createdAt, order: .forward)]
        )

        do {
            entries = try modelContext.fetch(descriptor).map(\.entry)
            lastErrorMessage = nil
            refreshWidgetSnapshot()
        } catch {
            lastErrorMessage = "Could not load local orbit data."
            publishError("Could not load local data")
        }
    }

    @MainActor
    func publishSuccess(_ message: String) {
        feedback = OrbitFeedback(message: message, style: .success)
    }

    @MainActor
    func publishError(_ message: String) {
        feedback = OrbitFeedback(message: message, style: .error)
    }

    @MainActor
    private func saveAndRefresh(recentlyAddedID: OrbitEntry.ID? = nil, successMessage: String? = nil) -> Bool {
        guard let modelContext else {
            publishError("Local store is not ready")
            return false
        }

        do {
            try modelContext.save()
            if let recentlyAddedID {
                self.recentlyAddedID = recentlyAddedID
            }
            refresh()
            if let successMessage {
                publishSuccess(successMessage)
            }
            return true
        } catch {
            lastErrorMessage = "Could not save local orbit data."
            publishError("Could not save local data")
            return false
        }
    }

    @MainActor
    private func model(for id: OrbitEntry.ID) -> OrbitEntryModel? {
        guard let modelContext else {
            return nil
        }

        let descriptor = FetchDescriptor<OrbitEntryModel>()
        do {
            return try modelContext.fetch(descriptor).first { $0.id == id }
        } catch {
            lastErrorMessage = "Could not find local orbit point."
            publishError("Could not find orbit point")
            return nil
        }
    }

    @MainActor
    private func refreshWidgetSnapshot() {
        do {
            widgetSnapshot = try WidgetSnapshotService.writeTodaySnapshot(entries: entries)
        } catch {
            recordWidgetSnapshotFailure()
        }
    }

    @MainActor
    private func recordWidgetSnapshotFailure() {
        lastErrorMessage = "Could not update widget snapshot."
    }
}
