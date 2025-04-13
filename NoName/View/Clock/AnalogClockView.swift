import SwiftUI


struct AnalogClockView: View {
    @ObservedObject var currentTime = CurrentTime()
    @Binding var zoomSegment: Bool
    @EnvironmentObject var timeModel: TimeModel
    
    var body: some View {
        
        GeometryReader { geometry in
            let bigCircleFrame = (geometry.size.width * 390)/402
            let littleCircleFrame = (geometry.size.width * 320)/402
            ZStack {
                ZStack {
                    Circle().fill(.white)
                    ToDoView(zoomSegment: $zoomSegment)
                    Circle().strokeBorder(lineWidth: 4)
                }.frame(width: bigCircleFrame, height: bigCircleFrame)
                
                ZStack {
                    Circle().fill(.black)
                    Circle()
                        .stroke(lineWidth: 5)
                    ForEach(0..<60) { tick in
                        VStack {
                            Rectangle()
                                .fill(.white)
                                .opacity(0.8)
                                .frame(width: 2, height: tick % 5 == 0 ? 15 : 7)
                            Spacer()
                        }
                        .rotationEffect(.degrees(Double(tick)/60 * 360))
                    }
                    
                    ForEach(1..<13) { tick in
                        VStack {
                            Text("\(tick)")
                                .font(.title)
                                .foregroundStyle(.white)
                                .opacity(0.8)
                                .rotationEffect(.degrees(-Double(tick)/12 * 360))
                            Spacer()
                        }
                        .rotationEffect(.degrees(Double(tick)/12 * 360))
                    }.padding(20)
                    
                    
                    // hour
                    
                    
                    
                }.frame(width: littleCircleFrame, height: littleCircleFrame)
            }.position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}


#Preview {
    AnalogClockView(zoomSegment: .constant(false))
        .environmentObject(DateModel())
        .environmentObject(TimeModel())
        .environmentObject(TaskModel()) 
}
