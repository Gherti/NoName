import SwiftData
import SwiftUI

@Model
final class Task{
    var id: UUID
    var name: String
    var luogo: String
    var startTime: Date
    var endTime: Date
    var startDate: Date
    var endDate: Date

    init(name: String = "", luogo: String = "", startTime: Date = .now, endTime: Date = .now, startDate: Date = .now, endDate: Date = .now) {
        self.name = name
        self.luogo = luogo
        self.startTime = startTime
        self.endTime = endTime
        self.startDate = startDate
        self.endDate = endDate
        self.id = UUID()
    }
}


