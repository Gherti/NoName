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
    
    var tasksForToday: [Task] {
        taskModel.getTasks(selectedDate: (Calendar.current.component(.year, from: Date()),Calendar.current.component(.month, from: Date()),Calendar.current.component(.day, from: Date())))
            .sorted { $0.startDateTime < $1.startDateTime }
    }
    
    func isTaskAcrossNoon(task: Task) -> Bool {
            let startHour = Calendar.current.component(.hour, from: task.startDateTime)
            let endHour = Calendar.current.component(.hour, from: task.endDateTime)
            return startHour < 12 && endHour >= 12
        }
    // View
    var body: some View {
        GeometryReader { geometry in
            let bigCircleFrame = (geometry.size.width * 380) / 402
            let littlCircleFrame = (geometry.size.width * 320) / 402
            ZStack {
                Circle().fill(.white)
                ForEach(tasksForToday) { task in
                    let (startAngle, endAngle) = timeModel.timeSize(task)
                    if startAngle != endAngle{
                        
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
                            if let tag = task.tag, !tag.emoji.isEmpty && endAngle.degrees - startAngle.degrees >= 7{
                                EmojiView(
                                    emoji: tag.emoji,
                                    startAngle: startAngle,
                                    endAngle: endAngle,
                                    radius: (bigCircleFrame/4 - littlCircleFrame/4) + littlCircleFrame/2,
                                    center: CGPoint(x: bigCircleFrame/2, y: bigCircleFrame/2)
                                )
                            }
                            
                            if isTaskAcrossNoon(task: task) {
                                ArrowView()
                                    .position(x: bigCircleFrame / 2, y: (bigCircleFrame -  littlCircleFrame) / 4)
                            }
                        }
                    }
                }
            }
            .frame(width: bigCircleFrame, height: bigCircleFrame)
            .overlay(DonutCutout(innerRadius: littlCircleFrame))
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

struct ArrowView: View {
    @EnvironmentObject var timeModel: TimeModel
    var body: some View {
        Image(systemName: timeModel.showClock ? "arrowtriangle.left.fill" : "arrowtriangle.right.fill") // Icona della freccia
            .resizable()
            .frame(width: 15, height: 15)
            .foregroundColor(.black)
        
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
        let radius = bigCircleFrame / 2

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
            .frame(width: innerRadius, height: innerRadius)
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

