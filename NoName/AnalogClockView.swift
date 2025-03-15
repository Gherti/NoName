import SwiftUI

struct AnalogClockView: View {
    var body: some View {
        ZStack {
            ZStack {
                Circle().fill(.white)
                ToDoView()
                Circle().strokeBorder(lineWidth: 4)
            }.frame(width: 390, height: 390)
        
        ZStack {
            Circle().fill(Color(.sRGB, red: 142/255, green: 202/255, blue: 230/255))
            Circle()
                .stroke(lineWidth: 5)
            ForEach(0..<60) { tick in
                VStack {
                    Rectangle()
                        .fill(.primary)
                        .opacity(1)
                        .frame(width: 2, height: tick % 5 == 0 ? 15 : 7)
                    Spacer()
                }
                .rotationEffect(.degrees(Double(tick)/60 * 360))
            }
            
            ForEach(1..<13) { tick in
                VStack {
                    Text("\(tick)")
                        .font(.title)
                        .rotationEffect(.degrees(-Double(tick)/12 * 360))
                    Spacer()
                }
                .rotationEffect(.degrees(Double(tick)/12 * 360))
            }.padding(20)
        }.frame(width: 320, height: 320)
        }
    }
}

#Preview {
    AnalogClockView()
}
