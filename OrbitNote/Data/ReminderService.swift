import Foundation
import UserNotifications

enum ReminderPermissionStatus: String {
    case notRequested
    case allowed
    case notAllowed

    var title: String {
        switch self {
        case .notRequested:
            return "Not requested"
        case .allowed:
            return "Allowed"
        case .notAllowed:
            return "Not allowed"
        }
    }
}

enum ReminderService {
    static let identifier = "orbitNote.eveningReminder"

    static func permissionStatus() async -> ReminderPermissionStatus {
        let settings = await notificationSettings()
        switch settings.authorizationStatus {
        case .notDetermined:
            return .notRequested
        case .authorized, .provisional, .ephemeral:
            return .allowed
        case .denied:
            return .notAllowed
        @unknown default:
            return .notAllowed
        }
    }

    static func requestPermission() async -> ReminderPermissionStatus {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])
            return granted ? .allowed : .notAllowed
        } catch {
            return .notAllowed
        }
    }

    static func scheduleDailyReminder(hour: Int, minute: Int) async throws {
        cancelReminder()

        let content = UNMutableNotificationContent()
        content.title = "Check your orbit"
        content.body = "What stayed close to your attention today?"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        try await UNUserNotificationCenter.current().add(request)
    }

    static func cancelReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }

    private static func notificationSettings() async -> UNNotificationSettings {
        await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                continuation.resume(returning: settings)
            }
        }
    }
}
