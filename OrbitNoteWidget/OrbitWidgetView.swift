import SwiftUI
import WidgetKit

struct OrbitWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: OrbitWidgetEntry

    var body: some View {
        ZStack {
            WidgetBackground()

            if let snapshot = entry.snapshot, snapshot.entryCount > 0 {
                content(for: snapshot)
            } else {
                emptyState
            }
        }
        .containerBackground(for: .widget) {
            Color(red: 0.02, green: 0.025, blue: 0.035)
        }
        .widgetURL(URL(string: "orbitnote://today"))
    }

    @ViewBuilder
    private func content(for snapshot: OrbitWidgetSnapshot) -> some View {
        switch family {
        case .systemMedium:
            mediumContent(snapshot)
        default:
            smallContent(snapshot)
        }
    }

    private func smallContent(_ snapshot: OrbitWidgetSnapshot) -> some View {
        VStack(alignment: .leading, spacing: 9) {
            header
            Spacer(minLength: 4)
            EnergyBadge(snapshot: snapshot)
            Text("\(snapshot.entryCount) orbit points")
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(WidgetPalette.secondary)
            Text(snapshot.closestTitle ?? "No close point")
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(WidgetPalette.primary)
                .lineLimit(2)
                .minimumScaleFactor(0.82)
        }
        .padding(16)
    }

    private func mediumContent(_ snapshot: OrbitWidgetSnapshot) -> some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 10) {
                header
                EnergyBadge(snapshot: snapshot)
                Text("\(snapshot.entryCount) orbit points today")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(WidgetPalette.secondary)
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading, spacing: 8) {
                WidgetMetric(label: "Closest", value: snapshot.closestTitle ?? "None")
                WidgetMetric(label: "Gives", value: snapshot.strongestPositiveTitle ?? "None")
                WidgetMetric(label: "Drains", value: snapshot.strongestDrainingTitle ?? "None")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
    }

    private var header: some View {
        HStack(spacing: 7) {
            Image(systemName: "circle.dotted")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(WidgetPalette.cyan)
            Text("Today Orbit")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(WidgetPalette.primary)
        }
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 10) {
            header
            Spacer(minLength: 0)
            Text("No orbit yet")
                .font(.system(size: 19, weight: .semibold, design: .rounded))
                .foregroundStyle(WidgetPalette.primary)
            Text("Open Orbit Note tonight and place what stayed close.")
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(WidgetPalette.secondary)
                .lineLimit(3)
                .minimumScaleFactor(0.85)
        }
        .padding(16)
    }
}

private struct WidgetBackground: View {
    var body: some View {
        ZStack {
            Color(red: 0.02, green: 0.025, blue: 0.035)

            Circle()
                .stroke(WidgetPalette.line, lineWidth: 1)
                .frame(width: 112, height: 112)
                .offset(x: 64, y: 38)

            Circle()
                .fill(WidgetPalette.cyan.opacity(0.18))
                .frame(width: 110, height: 110)
                .blur(radius: 28)
                .offset(x: 72, y: -48)

            Circle()
                .fill(WidgetPalette.pink.opacity(0.14))
                .frame(width: 92, height: 92)
                .blur(radius: 26)
                .offset(x: -78, y: 48)
        }
    }
}

private struct EnergyBadge: View {
    let snapshot: OrbitWidgetSnapshot

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 7, height: 7)
            Text(snapshot.dominantEnergyLabel)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(color)
                .lineLimit(1)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(Capsule().fill(color.opacity(0.14)))
    }

    private var color: Color {
        switch snapshot.dominantEnergyColorName {
        case "positive":
            return WidgetPalette.cyan
        case "draining":
            return WidgetPalette.pink
        default:
            return WidgetPalette.purple
        }
    }
}

private struct WidgetMetric: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.system(size: 10, weight: .medium, design: .rounded))
                .foregroundStyle(WidgetPalette.secondary)
                .textCase(.uppercase)
            Text(value)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(WidgetPalette.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
    }
}

private enum WidgetPalette {
    static let primary = Color(red: 0.92, green: 0.96, blue: 0.98)
    static let secondary = Color(red: 0.58, green: 0.64, blue: 0.72)
    static let cyan = Color(red: 0.28, green: 0.92, blue: 0.95)
    static let pink = Color(red: 1.0, green: 0.46, blue: 0.55)
    static let purple = Color(red: 0.68, green: 0.58, blue: 0.92)
    static let line = Color.white.opacity(0.13)
}
