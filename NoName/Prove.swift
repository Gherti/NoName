//
//  Prove.swift
//  NoName
//
//  Created by Nicoló Metani on 12/03/25.
//

import SwiftUI

struct DonutChartView: View {
    let segments: [(color: Color, value1: Double, value2: Double)] = [
        (.red, 20, 30),
        (.blue, 15, 15),
        (.green, 30, 30),
        (.orange, 20, 20),
        (.purple, 10, 10)
    ]

    var total: Double {
        segments.map { $0.value1 }.reduce(0, +)
    }

    var body: some View {
        ZStack {
            ForEach(0..<segments.count, id: \.self) { index in
                let startAngle = startangle(at: index)
                let endAngle = endangle(at: index)

                PieSlice(startAngle: startAngle, endAngle: endAngle)
                    .fill(segments[index].color)
            }
        }
        .frame(width: 390, height: 390)
        .overlay(DonutCutout(innerRadius: 162)) // Ritaglia il centro per creare la ciambella
    }

    func startangle(at index: Int) -> Angle {
        let valueSum = segments.prefix(index).map { $0.value1 }.reduce(0, +)
        return .degrees((valueSum / total) * 360 - 90) // -90 per iniziare dall'alto
    }
    
    func endangle(at index: Int) -> Angle {
        let valueSum = segments.prefix(index).map { $0.value2 }.reduce(0, +)
        return .degrees((valueSum / total) * 360 - 90) // -90 per iniziare dall'alto
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
            .blendMode(.destinationOut) // Ritaglia il centro usando un effetto di mascheratura
    }
}



struct Prove: View {
    var body: some View {
        DonutChartView()
                    .background(Color.white) // Necessario per il blendMode
                    .compositingGroup()
    }
}

#Preview {
    Prove()
}
