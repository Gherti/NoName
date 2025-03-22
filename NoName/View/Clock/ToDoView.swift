import SwiftUI
import SwiftData


struct ToDoView: View {
    @State private var selectedSegment: UUID? = nil
    @State private var pressedIndex: UUID? = nil
    
    // Oggetti provenienti da fuori
    @Binding var zoomSegment: Bool
    @EnvironmentObject var timeModel: TimeModel
    
    // Database
    @Query private var tasks: [Task]
    
    // Funzioni Angoli
    func angle(at orario: Date) -> Angle {
        let calendar = Calendar.current
        let minute = Double(calendar.component(.minute, from: orario) + calendar.component(.hour, from: orario) * 60)
        return .degrees(minute * 0.5 - 90)
    }
    
    func isAfterNoon(_ date: Date) -> Bool {
        let calendar = Calendar.current
        if timeModel.showClock == true {
            return calendar.component(.hour, from: date) >= 12
        } else {
            return calendar.component(.hour, from: date) < 12
        }
    }
    
    // Funzione per verificare se il task è del giorno corrente
    func isTaskForToday(_ task: Task) -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let start = calendar.startOfDay(for: task.startDate)
        let end = calendar.startOfDay(for: task.endDate)
        return today >= start && today <= end
    }
    
    func taskSize(_ task: Task) -> (startAng: Angle, endAng: Angle){
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let start = calendar.startOfDay(for: task.startDate)
        let end = calendar.startOfDay(for: task.endDate)
        
        
        
        if today > start && today < end {
            return (.degrees(-90), .degrees(270))
        }
        else if today == start && today < end{
            let startAng = Double(calendar.component(.minute, from: task.startTime) + calendar.component(.hour, from: task.startTime) * 60)
            return (.degrees(startAng * 0.5 - 90), .degrees(270))
        }
        else if today > start && today == end{
            let endAng = Double(calendar.component(.minute, from: task.endTime) + calendar.component(.hour, from: task.endTime) * 60)
            return (.degrees(-90), .degrees(endAng * 0.5 - 90))
        }
        else{
            let startAng = Double(calendar.component(.minute, from: task.startTime) + calendar.component(.hour, from: task.startTime) * 60)
            
            let endAng = Double(calendar.component(.minute, from: task.endTime) + calendar.component(.hour, from: task.endTime) * 60)
            return (.degrees(startAng * 0.5 - 90), .degrees(endAng * 0.5 - 90))
        }
    }
    
    // View
    var body: some View {
        GeometryReader { geometry in
            let bigCircleFrame = (geometry.size.width * 390) / 402
            let littlCircleFrame = (geometry.size.width * 320) / 402
            ZStack {
                ForEach(tasks) { task in
                    // Mostra il task solo se è del giorno corrente
                    if isTaskForToday(task) {
                        let (startAngle, endAngle) = taskSize(task)
                        if isAfterNoon(task.startTime) {
                            PieSlice(startAngle: startAngle, endAngle: endAngle, bigCircleFrame: bigCircleFrame, littlCircleFrame: littlCircleFrame)
                                .fill(.red)
                                .opacity((pressedIndex == task.id) ? 0.5 : 1)
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { _ in
                                            if pressedIndex != task.id {
                                                pressedIndex = task.id
                                                selectedSegment = task.id
                                                print("Hai cliccato il segmento di colore \(task.id)")
                                            }
                                        }
                                        .onEnded { _ in
                                            pressedIndex = nil
                                        }
                                )
                        }
                    }
                }
            }
            .frame(width: bigCircleFrame, height: bigCircleFrame)
            .overlay(DonutCutout(innerRadius: bigCircleFrame - littlCircleFrame))
            .compositingGroup()
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}



struct PieSlice: Shape {
    let startAngle: Angle
    let endAngle: Angle
    let bigCircleFrame: Double
    let littlCircleFrame: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: bigCircleFrame/2, y: bigCircleFrame/2)
        let radius = (bigCircleFrame / 2) + 2

        path.move(to: center)
        path.addArc(center: center, radius: radius,
                    startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.closeSubpath()

        return path
    }
}

struct DonutCutout: View {
    let innerRadius: CGFloat

    var body: some View {
        Circle()
            .frame(width: innerRadius * 2, height: innerRadius * 2)
            .blendMode(.destinationOut)
    }
}

#Preview {
    ToDoView(zoomSegment: .constant(false))
        .modelContainer(for: Task.self)
        .environmentObject(TimeModel())
        .environmentObject(ToDoModel())
}
