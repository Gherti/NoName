    import SwiftData
    import SwiftUI

@Model
final class Task {
    @Attribute(.unique) var id: UUID
    var name: String
    var location: String
    var startDateTime: Date
    var endDateTime: Date
    var endRepetition: Date?
    var tag: Tag?
    var repetition: Repetition?  // ✅ Now structured instead of a string
    var note: String

    init(
        name: String = "",
        location: String = "",
        startDateTime: Date = .now,
        endDateTime: Date = .now,
        endRepetition: Date? = nil,
        tag: Tag? = nil,
        repetition: Repetition? = nil,  // Default: no repetition
        note: String = ""
    ) {
        self.id = UUID()
        self.name = name
        self.location = location
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
        self.endRepetition = endRepetition
        self.tag = tag
        self.repetition = repetition
        self.note = note
    }
}

@Model
final class Tag {
    @Attribute(.unique) var id: UUID
    var name: String
    var color: String
    var emoji: String

    init(name: String = "", color: String = "#FFFFFF", emoji: String = "") {
        self.id = UUID()
        self.name = name
        self.color = color
        self.emoji = emoji
    }
}



enum RepetitionUnit: String, Codable, CaseIterable {
    case day, week, month, year
}

struct Repetition: Codable {
    var interval: Int  // How often (e.g., every 2 weeks → interval = 2)
    var unit: RepetitionUnit  // Unit type (day, week, month, year)
}
