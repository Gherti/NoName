import SwiftUI
import SwiftData


struct ToDoView: View {
    @State private var selectedSegment: UUID? = nil
    @State private var pressedIndex: UUID? = nil
    
    // Oggetti provenienti da fuori
    @Binding var zoomSegment: Bool
    @EnvironmentObject var timeModel: TimeModel
    @EnvironmentObject var toDoModel: ToDoModel
    
    
    // Database
    @Query private var tasks: [Task]
    //DA AGGIUSTARE E IMPLEMENTARE IL FETCH
    
    
    
    // View
    var body: some View {
        GeometryReader { geometry in
            let bigCircleFrame = (geometry.size.width * 390) / 402
            let littlCircleFrame = (geometry.size.width * 320) / 402
            ZStack {
                ForEach(tasks) { task in
                    let (startAngle, endAngle) = taskSize(task)
                    if startAngle != Angle.degrees(0) || endAngle != Angle.degrees(0) {
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
            .frame(width: bigCircleFrame, height: bigCircleFrame)
            .overlay(DonutCutout(innerRadius: bigCircleFrame - littlCircleFrame))
            .compositingGroup()
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
    
    func taskSize(_ task: Task) -> (startAng: Angle, endAng: Angle){
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let start = calendar.startOfDay(for: task.startDate)
        let end = calendar.startOfDay(for: task.endDate)
        var startAng: Double = 0.0
        var endAng: Double = 0.0
        
        if today > start && today < end {
            startAng = 0.0
            endAng = 1440.0
        }
        else if today == start && today < end{
            startAng = Double(calendar.component(.minute, from: task.startTime) + calendar.component(.hour, from: task.startTime) * 60)
            endAng = 1440.0
            
        }
        else if today > start && today == end{
            startAng = 0.0
            endAng = Double(calendar.component(.minute, from: task.endTime) + calendar.component(.hour, from: task.endTime) * 60)
        }
        else if today == start && today == end{
            startAng = Double(calendar.component(.minute, from: task.startTime) + calendar.component(.hour, from: task.startTime) * 60)
            
            endAng = Double(calendar.component(.minute, from: task.endTime) + calendar.component(.hour, from: task.endTime) * 60)
        }
        if startAng != 0 || endAng != 0{
                if startAng >= 720 && endAng > 720 && timeModel.showClock == true{
                return (.degrees(startAng * 0.5 - 90), .degrees(endAng * 0.5 - 90))
            }
            else if startAng < 720 && endAng <= 720 && timeModel.showClock == false{
                return (.degrees(startAng * 0.5 - 90), .degrees(endAng * 0.5 - 90))
            }
            else if startAng < 720 && endAng > 720 && timeModel.showClock == true{
                return (.degrees(720 * 0.5 - 90), .degrees(endAng * 0.5 - 90))
            }
            else if startAng < 720 && endAng > 720 && timeModel.showClock == false{
                return (.degrees(startAng * 0.5 - 90), .degrees(720 * 0.5 - 90))
            }
        }
        return (.degrees(0), .degrees(0))
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
        //.modelContainer(for: Task.self)
        .environmentObject(DateModel())
        .environmentObject(TimeModel())
        .environmentObject(ToDoModel()) 
}
