import SwiftUI
import SwiftData


struct ToDoView: View {
    @State private var selectedSegment: UUID? = nil
    @State private var pressedIndex: UUID? = nil
    
    // Oggetti provenienti da fuori
    @Binding var zoomSegment: Bool
    @EnvironmentObject var timeModel: TimeModel
    @EnvironmentObject var taskModel: TaskModel
    @EnvironmentObject var dateModel: DateModel
    @Environment(\.modelContext) var context
    
    // Database
    //@Query private var tasks: [Task]
    //DA AGGIUSTARE E IMPLEMENTARE IL FETCH
    
    
    // View
    var body: some View {
        GeometryReader { geometry in
            let bigCircleFrame = (geometry.size.width * 390) / 402
            let littlCircleFrame = (geometry.size.width * 320) / 402
            ZStack {
                ForEach(taskModel.tasks) { task in
                    let (startAngle, endAngle) = timeModel.timeSize(task)
                    if startAngle != Angle.degrees(0) || endAngle != Angle.degrees(0) {
                        PieSlice(startAngle: startAngle, endAngle: endAngle, bigCircleFrame: bigCircleFrame, littlCircleFrame: littlCircleFrame)
                            .fill(.red)
                            .opacity((pressedIndex == task.id) ? 0.5 : 1)
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { _ in
                                        if pressedIndex != task.id {
                                            pressedIndex = task.id
                                        }
                                    }
                                    .onEnded { _ in
                                        withAnimation(.bouncy){
                                            dateModel.seeTaskInfo(taskSelected: task)
                                        }
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
        .onAppear {
            taskModel.fetchTasks(context: context)
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
        //.modelContainer(for: Task.self)
        .environmentObject(DateModel())
        .environmentObject(TimeModel())
        .environmentObject(TaskModel())
}
