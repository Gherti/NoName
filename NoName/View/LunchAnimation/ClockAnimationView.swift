import SwiftUI

struct ClockAnimationView: View {
    @Binding var showMainView: Bool
    @State private var hourAngle: Double = 0
    @State private var minuteAngle: Double = 0
    @State private var secondAngle: Double = 0
    @State private var animationEnded = false

    // Altezza stimata della tab bar
    private let tabBarHeight: CGFloat = 50

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Sfondo full‑screen
                Color("Background")
                    .ignoresSafeArea()

                // Il “quadrante” animato
                ZStack {
                    AnimatedClockHandsView(
                        hourAngle: $hourAngle,
                        minuteAngle: $minuteAngle,
                        secondAngle: $secondAngle
                    )
                }
                .frame(width: (geo.size.width * 320) / 402,
                       height: (geo.size.width * 320) / 402)
                // posizione al centro dell'area di contenuto (escludendo tab bar)
                .position(
                    x: geo.size.width / 2,
                    y: (geo.size.height - tabBarHeight) / 2
                )
                .opacity(animationEnded ? 0 : 1)
            }
            .onAppear {
                animateClock()
            }
        }
    }

    func animateClock() {
        let cal = Calendar.current
        let now = Date()
        
        let h24 = Double(cal.component(.hour, from: now))
        let h12 = h24.truncatingRemainder(dividingBy: 12)
        let m = Double(cal.component(.minute, from: now))
        let s = Double(cal.component(.second, from: now))
        
        // start da 00:00
        hourAngle = 0
        minuteAngle = 0
        secondAngle = 0
        
        // secondi totali in un orologio 12h
        let totalSecs12 = h12 * 3600 + m * 60 + s
        
        let steps = 60
        let stepDur = 0.015
        var currentStep = 0
        
        Timer.scheduledTimer(withTimeInterval: stepDur, repeats: true) { timer in
            if currentStep < steps {
                let p = Double(currentStep) / Double(steps)
                let eased = 1 - pow(1 - p, 2.5)
                
                let simSecs = totalSecs12 * eased
                
                // Direct calculation for minute hand - using exact same formula as final position
                let currentMin = m * eased
                let currentSec = s * eased
                minuteAngle = (currentMin / 60 + currentSec / 3600) * 360
                
                // Keep original calculations for hour and second hands
                secondAngle = (simSecs.truncatingRemainder(dividingBy: 60) / 60) * 360
                hourAngle = (simSecs / 43200) * 360
                
                currentStep += 1
            } else {
                // posizione esatta
                hourAngle = (h12 / 12 + m / (12 * 60) + s / (12 * 3600)) * 360
                minuteAngle = (m / 60 + s / 3600) * 360
                secondAngle = (s / 60) * 360
                
                timer.invalidate()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    withAnimation {
                        animationEnded = true
                        showMainView = true
                    }
                }
            }
        }
    }
}

// Resto invariato
struct AnimatedClockHandsView: View {
    @Binding var hourAngle: Double
    @Binding var minuteAngle: Double
    @Binding var secondAngle: Double

    var body: some View {
        ZStack {
            CustomClockHand(angleMultipler: hourAngle / 360, scale: 0.5)
                .stroke(Color("ClockHand"), lineWidth: 3)

            CustomClockHand(angleMultipler: minuteAngle / 360, scale: 0.6)
                .stroke(Color("ClockHand"), lineWidth: 2)

            // de-commenta per avere anche i secondi
            // CustomClockHand(angleMultipler: secondAngle / 360, scale: 0.7)
            //     .stroke(.red, lineWidth: 1)

            Circle()
                .fill(Color("ClockHand"))
                .frame(width: 8, height: 8)
            Circle()
                .fill(Color("ClockHand"))
                .frame(width: 4, height: 4)
        }
    }
}

struct CustomClockHand: Shape {
    let angleMultipler: CGFloat
    let scale: CGFloat

    func path(in rect: CGRect) -> Path {
        Path { path in
            let length = rect.width / 2
            let center = CGPoint(x: rect.midX, y: rect.midY)

            path.move(to: center)
            let angle = .pi / 2 - (.pi * 2 * angleMultipler)
            path.addLine(to: CGPoint(
                x: center.x + cos(angle) * length * scale,
                y: center.y - sin(angle) * length * scale
            ))
        }
    }
}

#Preview {
    ClockAnimationView(showMainView: .constant(false))
        .environmentObject(DateModel())
        .environmentObject(TimeModel())
        .environmentObject(TaskModel())
}
