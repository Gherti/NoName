import SwiftUI

struct DonutChartView: View {
    @State private var selectedSegment: Int? = nil // Tiene traccia del segmento selezionato
    @State private var pressedIndex: Int? = nil // Tiene traccia del segmento attualmente premuto
    @Binding var zoomSegment: Bool
    let segments: [(color: Color, value1: Double, value2: Double)] = [
        (.red, 0, 0.2),
        (.blue, 0.4, 0.6),
        (.black, 6, 12)
    ]
    
    //Funzioni Angoli
    func startangle(at index: Int) -> Angle {
        return .degrees(segments[index].value1 * 60 * 0.5 - 90)
    }

    func endangle(at index: Int) -> Angle {
        return .degrees(segments[index].value2 * 60 * 0.5 - 90)
    }
    
    //View
    var body: some View {
        ZStack {
            ForEach(0..<segments.count, id: \.self) { index in
                let startAngle = startangle(at: index)
                let endAngle = endangle(at: index)

                PieSlice(startAngle: startAngle, endAngle: endAngle)
                    .fill(segments[index].color)
                    .opacity((pressedIndex == index) ? 0.5 : 1) // Cambia opacità solo per il segmento premuto
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { _ in
                                if pressedIndex != index { // Previene cambiamenti errati
                                    zoomSegment = true
                                    pressedIndex = index
                                    selectedSegment = index
                                    print("Hai cliccato il segmento di colore \(segments[index].color)")
                                }
                            }
                            .onEnded { _ in
                                pressedIndex = nil // Ripristina l'opacità quando si rilascia il dito
                            }
                    )
            }
        }
        .frame(width: 390, height: 390)
        .overlay(DonutCutout(innerRadius: 160)) // Ritaglia il centro per creare la ciambella
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


/// View
struct ToDoView: View {
    @Binding var zoomSegment: Bool
    var body: some View {
        DonutChartView(zoomSegment: $zoomSegment).compositingGroup()
    }
}

#Preview {
    ToDoView(zoomSegment: .constant(false))
}
