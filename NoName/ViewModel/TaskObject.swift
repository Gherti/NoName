import SwiftData
import SwiftUI

@Model
final class Task {
    @Attribute(.unique) var id: UUID
    var name: String
    var location: String
    var startDateTime: Date
    var endDateTime: Date
    var tags: [Tag] // Relazione molti-a-molti

    init(
        name: String = "",
        location: String = "",
        startDateTime: Date = .now,
        endDateTime: Date = .now,
        tags: [Tag] = []
    ) {
        self.id = UUID()
        self.name = name
        self.location = location
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
        self.tags = tags
    }
}

@Model
final class Tag {
    @Attribute(.unique) var id: UUID
    var name: String
    var color: String  // Usa un tipo String per memorizzare il colore in formato esadecimale o come nome
    var emoji: String  // Usa una stringa per memorizzare l'emoji

    init(name: String = "", color: String = "#FFFFFF", emoji: String = "") {
        self.id = UUID()
        self.name = name
        self.color = color
        self.emoji = emoji
    }
}
