import Foundation
import SwiftUI

struct OrbitCanvas: View {
    let entries: [OrbitEntry]
    var compact = false
    var recentlyAddedID: OrbitEntry.ID?
    var onSelect: ((OrbitEntry) -> Void)?

    @State private var breathing = false

    var body: some View {
        TimelineView(.animation(minimumInterval: 1 / 30)) { timeline in
            let phase = CGFloat(timeline.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 120))

            GeometryReader { proxy in
                let size = min(proxy.size.width, proxy.size.height)
                let center = CGPoint(x: proxy.size.width / 2, y: proxy.size.height / 2)

                ZStack {
                    orbitLines(size: size)
                        .scaleEffect(breathing ? 1.012 : 0.996)
                        .opacity(breathing ? 0.82 : 0.58)

                    centerPoint(compact: compact)
                        .position(center)

                    ForEach(Array(entries.enumerated()), id: \.element.id) { index, entry in
                        let point = position(for: entry, index: index, size: size, center: center, phase: phase)
                        Button {
                            onSelect?(entry)
                        } label: {
                            OrbitPoint(
                                entry: entry,
                                isNew: entry.id == recentlyAddedID,
                                compact: compact,
                                phase: phase + CGFloat(index)
                            )
                        }
                        .buttonStyle(PressScaleButtonStyle())
                        .position(point)
                        .disabled(onSelect == nil)
                    }
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 4.8).repeatForever(autoreverses: true)) {
                breathing = true
            }
        }
    }

    private func orbitLines(size: CGFloat) -> some View {
        ZStack {
            ForEach([0.32, 0.58, 0.86], id: \.self) { scale in
                Circle()
                    .stroke(OrbitTheme.orbitLine, lineWidth: compact ? 0.7 : 1)
                    .frame(width: size * scale, height: size * scale)
            }

            ForEach(0..<12, id: \.self) { index in
                Rectangle()
                    .fill(OrbitTheme.orbitLine.opacity(index.isMultiple(of: 3) ? 0.70 : 0.34))
                    .frame(width: compact ? 6 : 10, height: 1)
                    .offset(x: size * 0.43)
                    .rotationEffect(.degrees(Double(index) * 30))
            }
        }
    }

    private func centerPoint(compact: Bool) -> some View {
        ZStack {
            Circle()
                .fill(OrbitTheme.positive.opacity(0.10))
                .frame(width: compact ? 30 : 54, height: compact ? 30 : 54)
                .blur(radius: 8)

            Circle()
                .fill(OrbitTheme.background)
                .frame(width: compact ? 18 : 34, height: compact ? 18 : 34)
                .overlay(Circle().stroke(OrbitTheme.positive.opacity(0.8), lineWidth: 1))

            if !compact {
                Text("ME")
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .foregroundStyle(OrbitTheme.positive)
            }
        }
    }

    private func position(for entry: OrbitEntry, index: Int, size: CGFloat, center: CGPoint, phase: CGFloat) -> CGPoint {
        let radius = (size / 2) * entry.distance.radiusMultiplier
        let angle = deterministicAngle(for: entry, index: index) + sin(phase / 12 + CGFloat(index)) * 0.035
        let drift = cos(phase / 10 + CGFloat(index)) * (compact ? 1.2 : 3.2)

        return CGPoint(
            x: center.x + cos(angle) * (radius + drift),
            y: center.y + sin(angle) * (radius + drift)
        )
    }

    private func deterministicAngle(for entry: OrbitEntry, index: Int) -> CGFloat {
        let scalar = entry.title.unicodeScalars.reduce(0) { $0 + Int($1.value) }
        let degrees = (scalar + index * 47) % 360
        return CGFloat(Double(degrees) * Double.pi / 180)
    }
}
