import SwiftData
import SwiftUI

@Model
final class Task {
    @Attribute(.unique) var id: UUID
    var name: String
    var location: String
    var startDateTime: Date
    var endDateTime: Date
    
    init(
        name: String = "",
        location: String = "",
        startDateTime: Date = .now,
        endDateTime: Date = .now
    ) {
        self.id = UUID()
        self.name = name
        self.location = location
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
    }
}

