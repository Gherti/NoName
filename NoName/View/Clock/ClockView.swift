import SwiftUI
import SwiftData

struct ClockView: View {
    @EnvironmentObject var timeModel: TimeModel
    
    @State var zoomSegment: Bool = false
    @State private var isSheetPresented = false
    
    var body: some View {
            ZStack{
                Color(.sRGB, red: 142/255, green: 202/255, blue: 230/255).ignoresSafeArea(.all)
                
                VStack{
                    HStack{
                        Text("Clock").padding().font(.system(size: 30, weight: .bold, design: .default))
                        Spacer()
                        
                        Button(action:{
                            if !isSheetPresented {
                                isSheetPresented = true
                            }
                        }, label:{
                            Image(systemName: "plus.circle").font(.system(size: 35))
                                .foregroundStyle(.black).padding()
                        }).sheet(isPresented: $isSheetPresented){
                            BotttomSheetView()
                        }
                        
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        
                        Button(action:{
                            timeModel.toggleClock()
                        }){
                            Image(systemName: timeModel.showClock ? "moon.fill" : "sun.max.fill").font(.system(size: 35))
                                .foregroundStyle(.black).padding().padding(.bottom, 60.0)
                            
                        }
                    }
                }.shadow(radius: 5)
                
                if zoomSegment == false{ // OROLOGIO
                    AnalogClockView(zoomSegment: $zoomSegment)
                }
                else{ // ZOOM
                    ZoomView()
                }
            }
    }
}

#Preview {
    ClockView()
        .environmentObject(DateModel())
        .environmentObject(TimeModel())
        .environmentObject(TaskModel()) 
}
