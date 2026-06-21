import Foundation

struct TodayOrbitInsight: Codable, Equatable {
    var generatedAt: Date
    var date: Date
    var entryCount: Int
    var headline: String
    var summary: String
    var focusTitle: String?
    var positiveTitle: String?
    var drainingTitle: String?
    var suggestedPrompt: String
}
