import SwiftUI

struct EnergyPill: View {
    let energy: EnergyType
    var isSelected = false

    var body: some View {
        Label(energy.title, systemImage: symbol)
            .font(OrbitTheme.caption)
            .foregroundStyle(isSelected ? OrbitTheme.background : energy.color)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
            .background(
                Capsule()
                    .fill(isSelected ? energy.color : energy.color.opacity(0.12))
                    .overlay(Capsule().stroke(energy.color.opacity(0.42), lineWidth: 1))
            )
    }

    private var symbol: String {
        switch energy {
        case .positive: "arrow.up.right"
        case .draining: "arrow.down.right"
        case .neutral: "minus"
        }
    }
}

struct CategoryPill: View {
    let category: OrbitCategory
    var isSelected = false

    var body: some View {
        Label(category.title, systemImage: category.symbol)
            .font(OrbitTheme.caption)
            .foregroundStyle(isSelected ? OrbitTheme.background : OrbitTheme.textPrimary)
            .lineLimit(1)
            .minimumScaleFactor(0.76)
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
            .background(
                Capsule()
                    .fill(isSelected ? OrbitTheme.positive : OrbitTheme.glassSurface)
                    .overlay(Capsule().stroke(OrbitTheme.borderSubtle, lineWidth: 1))
            )
    }
}

struct DistanceSelector: View {
    @Binding var selection: OrbitDistance

    var body: some View {
        HStack(spacing: 8) {
            ForEach(OrbitDistance.allCases) { distance in
                Button {
                    selection = distance
                } label: {
                    VStack(spacing: 4) {
                        Text(distance.title)
                            .font(OrbitTheme.caption)
                        Text(distance.summary)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(selection == distance ? OrbitTheme.background.opacity(0.72) : OrbitTheme.textSecondary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.64)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(selection == distance ? OrbitTheme.positive : OrbitTheme.glassSurface)
                            .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(OrbitTheme.borderSubtle, lineWidth: 1))
                    )
                    .foregroundStyle(selection == distance ? OrbitTheme.background : OrbitTheme.textPrimary)
                }
                .buttonStyle(PressScaleButtonStyle())
            }
        }
    }
}

struct IntensitySlider: View {
    @Binding var intensity: Double

    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .lastTextBaseline) {
                Text("Impact strength")
                    .font(OrbitTheme.caption)
                    .foregroundStyle(OrbitTheme.textSecondary)
                Spacer()
                Text("\(Int(intensity.rounded()))")
                    .font(.system(size: 30, weight: .semibold, design: .rounded))
                    .foregroundStyle(OrbitTheme.textPrimary)
                Text("/5")
                    .font(OrbitTheme.numeric)
                    .foregroundStyle(OrbitTheme.textSecondary)
            }

            Slider(value: $intensity, in: 1...5, step: 1)
                .tint(OrbitTheme.positive)

            HStack {
                ForEach(1...5, id: \.self) { index in
                    Text("\(index)")
                        .font(OrbitTheme.numeric)
                        .foregroundStyle(Int(intensity.rounded()) == index ? OrbitTheme.positive : OrbitTheme.textSecondary)
                    if index != 5 { Spacer() }
                }
            }
        }
    }
}
