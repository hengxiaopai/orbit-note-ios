import SwiftUI

struct OrbitPoint: View {
    let entry: OrbitEntry
    var isNew = false
    var phase: CGFloat = 0

    var body: some View {
        let size = CGFloat(12 + entry.intensity * 4)
        ZStack {
            Circle()
                .fill(entry.energyType.color.opacity(0.20))
                .frame(width: size * 2.8, height: size * 2.8)
                .blur(radius: 12)

            Circle()
                .fill(entry.energyType.color)
                .frame(width: size, height: size)
                .shadow(color: entry.energyType.color.opacity(0.55), radius: 12)

            Image(systemName: entry.category.symbol)
                .font(.system(size: max(9, size * 0.42), weight: .semibold))
                .foregroundStyle(OrbitTheme.background.opacity(0.88))
        }
        .accessibilityLabel("\(entry.title), \(entry.energyType.shortTitle), intensity \(entry.intensity)")
        .scaleEffect(isNew ? 1.14 : 1)
        .opacity(isNew ? 0.94 : 1)
        .offset(y: sin(phase) * 2.5)
        .animation(.spring(response: 0.7, dampingFraction: 0.82), value: isNew)
    }
}
