//
//  ClockHandsView.swift
//  NoName
//
//  Created by Nicoló Metani on 14/04/25.
//

import SwiftUI
import Combine

struct ClockHandsView: View {
    @ObservedObject var currentTime = CurrentTime()
    @EnvironmentObject var timeModel: TimeModel
    var body: some View {
        ZStack {
            
            let forcedToNoon = timeModel.showClock == (Calendar.current.component(.hour, from: Date()) >= 12)
            
            let referenceTime = !forcedToNoon ? 0.0 : currentTime.seconds
            // Hour hand
            Hand(angleMultipler: referenceTime / (60 * 12) / 60, scale: 0.5)
                .stroke(Color("ClockHand"), style: StrokeStyle(lineWidth: 3, lineCap: .round))

            // Minute hand
            Hand(angleMultipler: referenceTime / 60 / 60, scale: 0.6)
                .stroke(Color("ClockHand"), style: StrokeStyle(lineWidth: 2, lineCap: .round))

            // Second hand (se vuoi attivarla)
            Hand(angleMultipler: referenceTime.remainder(dividingBy: 60) / 60, scale: 0.7)
                .stroke(.red, lineWidth: 1)

            // Center point
            Circle()
                .fill(Color("ClockHand"))
                .frame(width: 5, height: 5)
            Circle()
                .fill(Color("ClockHandReversed"))
                .frame(width: 2, height: 2)
        }
    }
}

class CurrentTime: ObservableObject {
    @Published var seconds = Double.zero
    
    private let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()
    private var cancellableSet = Set<AnyCancellable>()
    
    init() {
        timer.map { date in
            let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
            let referenceDate = Calendar.current.date(
                from: DateComponents(
                    year: components.year,
                    month: components.month,
                    day: components.day
                )
            )!
            return Date().timeIntervalSince(referenceDate)
        }
        .assign(to: \.seconds, on: self)
        .store(in: &cancellableSet)
    }
}

struct Hand: Shape {
    let angleMultipler: CGFloat
    let scale: CGFloat
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            let length = rect.width / 2
            let center = CGPoint(x: rect.midX, y: rect.midY)
            
            path.move(to: center)
            
            let angle = CGFloat.pi/2 - CGFloat.pi * 2 * angleMultipler
            
            path.addLine(to: CGPoint(
                x: rect.midX + cos(angle) * length * scale,
                y: rect.midY - sin(angle) * length * scale
            ))
        }
    }
}

#Preview {
    ClockHandsView()
        .environmentObject(DateModel())
        .environmentObject(TimeModel())
        .environmentObject(TaskModel())
}
