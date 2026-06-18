import SwiftUI
import WidgetKit

struct OrbitNoteWidget: Widget {
    let kind = "OrbitNoteWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: OrbitWidgetProvider()) { entry in
            OrbitWidgetView(entry: entry)
        }
        .configurationDisplayName("Today Orbit")
        .description("A quiet snapshot of today's dominant energy and closest orbit points.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
