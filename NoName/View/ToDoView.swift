import SwiftUI
import SwiftData


struct ToDoView: View {
    @State private var selectedSegment: UUID? = nil
    @State private var pressedIndex: UUID? = nil
    
    //Oggetti provenienti da fuori
    @Binding var zoomSegment: Bool
    @EnvironmentObject var timeModel: TimeModel
    
    //Database
    @Query private var tasks: [Task]
    
    //Funzioni Angoli
    func angle(at orario: Date ) -> Angle {
        let calendar = Calendar.current
        let minute = Double(calendar.component(.minute, from: orario) + calendar.component(.hour, from: orario)*60)
        return .degrees(minute * 0.5 - 90)
    }
    
    func isAfterNoon(_ date: Date) -> Bool {
        let calendar = Calendar.current
        if timeModel.showClock == true{
            return calendar.component(.hour, from: date) >= 12
        }
        else{
            return calendar.component(.hour, from: date) < 12
        }
    }
    //View
    var body: some View {
        
        GeometryReader { geometry in
            let bigCircleFrame = (geometry.size.width * 390)/402
            ZStack {
                ForEach(tasks) { task in
                    let startAngle = angle(at: task.start)
                    let endAngle = angle(at: task.end)
                    if isAfterNoon(task.start){
                        PieSlice(startAngle: startAngle, endAngle: endAngle)
                            .fill(.red)
                            .opacity((pressedIndex == task.id) ? 0.5 : 1) // Cambia opacità solo per il segmento premuto
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { _ in
                                        if pressedIndex != task.id { // Previene cambiamenti errati
                                            pressedIndex = task.id
                                            selectedSegment = task.id
                                            print("Hai cliccato il segmento di colore \(task.id)")
                                        }
                                    }
                                    .onEnded { _ in
                                        pressedIndex = nil // Ripristina l'opacità quando si rilascia il dito
                                    }
                            )
                    }
                    
                }
            }
            .frame(width: bigCircleFrame, height: bigCircleFrame)
            .overlay(DonutCutout(innerRadius: 160))
            .compositingGroup()
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }// Ritaglia il centro per creare la ciambella
    }
}


struct PieSlice: Shape {
    let startAngle: Angle
    let endAngle: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = rect.width / 2

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
    ToDoView(zoomSegment: .constant(false)).modelContainer(for: Task.self)
}
