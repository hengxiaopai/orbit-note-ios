import Foundation

enum DeepLinkDestination {
    case today
    case orbit
    case timeline
    case me

    var tab: AppTab {
        switch self {
        case .today, .orbit:
            return .orbit
        case .timeline:
            return .timeline
        case .me:
            return .me
        }
    }
}

enum DeepLinkRouter {
    static func destination(for url: URL) -> DeepLinkDestination? {
        guard url.scheme?.lowercased() == "orbitnote" else {
            return nil
        }

        let route = normalizedRoute(from: url)
        switch route {
        case "today":
            return .today
        case "orbit":
            return .orbit
        case "timeline":
            return .timeline
        case "me":
            return .me
        default:
            return nil
        }
    }

    private static func normalizedRoute(from url: URL) -> String {
        if let host = url.host, !host.isEmpty {
            return host.lowercased()
        }

        return url.path
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            .lowercased()
    }
}
