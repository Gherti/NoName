//
//  ZoomView.swift
//  NoName
//
//  Created by Nicoló Metani on 15/03/25.
//

import SwiftUI

struct ZoomView: View {
    var body: some View {
        ZStack{
            Circle().fill(Color(.sRGB, red: 142/255, green: 202/255, blue: 230/255))
            Circle().strokeBorder(lineWidth: 4)
            ZStack {
                //Circle().strokeBorder(lineWidth: 4)
            }.frame(width: 320, height: 320 )
            let startAngle = startangle()
            let endAngle = endangle()
            
            QuarterClock(startAngle:startAngle , endAngle:endAngle)
            QuarterClockInner(startAngle:startAngle , endAngle:endAngle).fill(Color(.sRGB, red: 142/255, green: 202/255, blue: 230/255))
        }.frame(width: 390, height: 390 )
    }
    
    func startangle() -> Angle {
        return .degrees(-90)
    }

    func endangle() -> Angle {
        return .degrees(0)
    }
    
}


struct QuarterClock: Shape {
    let startAngle: Angle
    let endAngle: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius = ((rect.width / 2) - 5) * 1.2
        let center = CGPoint(x: rect.midX-radius/3, y: rect.midY+radius/3)
        

        path.move(to: center)
        path.addArc(center: center, radius: radius,
                    startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.closeSubpath()

        return path
    }
}

struct QuarterClockInner: Shape {
    let startAngle: Angle
    let endAngle: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius = (rect.width / 2) - 5
        let center = CGPoint(x: rect.midX-radius/2.25, y: rect.midY+radius/2.25)
        

        path.move(to: center)
        path.addArc(center: center, radius: radius,
                    startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.closeSubpath()

        return path
    }
}
#Preview {
    ZoomView()
}
