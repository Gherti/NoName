import SwiftUI
import SwiftData

struct ToDoView: View {
    @State private var selectedSegment: UUID? = nil
    @State private var pressedIndex: UUID? = nil
    @State private var hasLoadedData: Bool = false
    // Oggetti provenienti da fuori
    @Binding var zoomSegment: Bool
    
    @EnvironmentObject var timeModel: TimeModel
    @EnvironmentObject var taskModel: TaskModel
    @EnvironmentObject var dateModel: DateModel
    @Environment(\.modelContext) var context
    
    // View
    var body: some View {
        GeometryReader { geometry in
            let bigCircleFrame = (geometry.size.width * 390) / 402
            let littlCircleFrame = (geometry.size.width * 320) / 402
            ZStack {
                ForEach(taskModel.tasks) { task in
                    let (startAngle, endAngle) = timeModel.timeSize(task)
                    if startAngle != Angle.degrees(0) || endAngle != Angle.degrees(0){
                        ZStack {
                            // Sezione del task
                            PieSlice(startAngle: startAngle, endAngle: endAngle, bigCircleFrame: bigCircleFrame, littlCircleFrame: littlCircleFrame)
                                .fill(Color(hex: task.tag?.color ?? "#808080"))
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
                            
                            // Posizionamento dell'emoji
                            if let tag = task.tag, !tag.emoji.isEmpty {
                                EmojiView(
                                    emoji: tag.emoji,
                                    startAngle: startAngle,
                                    endAngle: endAngle,
                                    radius: (bigCircleFrame + littlCircleFrame) / 3.9,
                                    center: CGPoint(x: bigCircleFrame/2, y: bigCircleFrame/2)
                                )
                            }
                        }
                    }
                }
            }
            .frame(width: bigCircleFrame, height: bigCircleFrame)
            .overlay(DonutCutout(innerRadius: bigCircleFrame - littlCircleFrame))
            .compositingGroup()
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
        .onAppear {
            if !hasLoadedData {
                taskModel.fetchTasks(context: context)
                taskModel.fetchTags(context: context)
                hasLoadedData = true
            }
        }
    }
}

struct EmojiView: View {
    let emoji: String
    let startAngle: Angle
    let endAngle: Angle
    let radius: CGFloat
    let center: CGPoint
    
    var body: some View {
        // Calcola l'angolo mediano del settore
        let midAngle = Angle(degrees: (startAngle.degrees + endAngle.degrees) / 2)
        
        // Calcola la posizione in coordinate cartesiane
        let angleInRadians = midAngle.radians
        let x = center.x + radius * cos(CGFloat(angleInRadians))
        let y = center.y + radius * sin(CGFloat(angleInRadians))
        
        // Ruota l'emoji in modo che la parte inferiore (default: verso il basso)
        // punti verso il centro. Per farlo, applica una rotazione pari a midAngle + 90°.
        return Text(emoji)
            .font(.system(size: 16))
            .rotationEffect(Angle(degrees: midAngle.degrees + 90))
            .position(x: x, y: y)
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

