import SwiftUI


struct AnalogClockView: View {
    @Binding var zoomSegment: Bool
    @EnvironmentObject var timeModel: TimeModel
    
    var body: some View {
        
        GeometryReader { geometry in
            let littleCircleFrame = (geometry.size.width * 320)/402
            ZStack {
                
                ToDoView(zoomSegment: $zoomSegment)
                
                ZStack {
                    Circle().fill(Color("ClockBackground"))
                    ForEach(0..<60) { tick in
                        VStack {
                            Rectangle()
                                .fill(Color("ClockNumNTick"))
                                .frame(width: 2, height: tick % 5 == 0 ? 15 : 7)
                            Spacer()
                        }
                        .rotationEffect(.degrees(Double(tick)/60 * 360))
                    }.padding(2)
                    
                    ForEach(1..<13) { tick in
                        VStack {
                            Text("\(tick)")
                                .font(.title2)
                                .foregroundStyle(Color("ClockNumNTick"))
                                .rotationEffect(.degrees(-Double(tick)/12 * 360))
                            Spacer()
                        }
                        .rotationEffect(.degrees(Double(tick)/12 * 360))
                    }.padding(20)
                    
                    
                    ClockHandsView()
                    
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
