import Combine
import Foundation
import SwiftData

final class OrbitStore: ObservableObject {
    @Published private(set) var entries: [OrbitEntry]
    @Published var recentlyAddedID: OrbitEntry.ID?
    @Published private(set) var lastErrorMessage: String?

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
            return true
        }

        modelContext.insert(OrbitEntryModel(entry: entry))
        return saveAndRefresh(recentlyAddedID: entry.id)
    }

    @MainActor
    @discardableResult
    func update(_ entry: OrbitEntry) -> Bool {
        guard let modelContext else {
            guard let index = entries.firstIndex(where: { $0.id == entry.id }) else {
                return false
            }
            entries[index] = entry
            return true
        }

        guard let model = model(for: entry.id) else {
            return false
        }

        model.apply(entry)
        return saveAndRefresh()
    }

    @MainActor
    @discardableResult
    func delete(_ entry: OrbitEntry) -> Bool {
        guard let modelContext else {
            entries.removeAll { $0.id == entry.id }
            return true
        }

        guard let model = model(for: entry.id) else {
            return false
        }

        modelContext.delete(model)
        return saveAndRefresh()
    }

    @MainActor
    func clearLocalData(reseed: Bool = false) {
        guard let modelContext else {
            entries = reseed ? OrbitSeedData.entries : []
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
        } catch {
            lastErrorMessage = "Could not clear local data."
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
        } catch {
            lastErrorMessage = "Could not load local orbit data."
        }
    }

    @MainActor
    private func saveAndRefresh(recentlyAddedID: OrbitEntry.ID? = nil) -> Bool {
        guard let modelContext else {
            return false
        }

        do {
            try modelContext.save()
            if let recentlyAddedID {
                self.recentlyAddedID = recentlyAddedID
            }
            refresh()
            return true
        } catch {
            lastErrorMessage = "Could not save local orbit data."
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
            return nil
        }
    }
}
