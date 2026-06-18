import SwiftUI

enum OrbitFeedbackStyle: Equatable {
    case success
    case error

    var color: Color {
        switch self {
        case .success:
            return OrbitTheme.positive
        case .error:
            return OrbitTheme.draining
        }
    }

    var symbol: String {
        switch self {
        case .success:
            return "checkmark.circle"
        case .error:
            return "exclamationmark.triangle"
        }
    }
}

struct OrbitFeedback: Identifiable, Equatable {
    let id = UUID()
    let message: String
    let style: OrbitFeedbackStyle
}

struct ToastBanner: View {
    let feedback: OrbitFeedback

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: feedback.style.symbol)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(feedback.style.color)

            Text(feedback.message)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(OrbitTheme.textPrimary)
                .lineLimit(2)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
        .background(
            Capsule()
                .fill(OrbitTheme.glassSurface)
                .background(.ultraThinMaterial, in: Capsule())
                .overlay(Capsule().stroke(feedback.style.color.opacity(0.34), lineWidth: 1))
        )
        .shadow(color: feedback.style.color.opacity(0.18), radius: 18, y: 8)
        .padding(.horizontal, 18)
    }
}
