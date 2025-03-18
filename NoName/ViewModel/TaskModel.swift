import SwiftData
import SwiftUI

@Model
final class Task{
    var id: UUID
    var name: String
    var luogo: String
    var start: Date
    var end: Date

    init(name: String = "", luogo: String = "", start: Date = .now, end: Date = .now) {
        self.name = name
        self.luogo = luogo
        self.start = start
        self.end = end
        self.id = UUID()
    }
}
