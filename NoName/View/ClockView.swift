import SwiftUI
import SwiftData

struct ClockView: View {
    @StateObject private var timeModel = TimeModel()
    @State var zoomSegment: Bool = false
    @State private var isSheetPresented = false
    
    var body: some View {
            VStack{
                ZStack(){
                    Color(.sRGB, red: 142/255, green: 202/255, blue: 230/255).ignoresSafeArea(.all)
                    
                    VStack{
                        HStack{
                            Text("Clock").padding().font(.system(size: 30, weight: .bold, design: .default))
                            Spacer()
                            
                            Button(action:{
                                isSheetPresented.toggle()
                            }, label:{
                                Image(systemName: "plus.circle").font(.system(size: 40))
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
                                Image(systemName: timeModel.showClock ? "moon.fill" : "sun.max.fill").font(.system(size: 40))
                                        .foregroundStyle(.black).padding().padding(.bottom, 60.0)
                                
                            }
                        }
                    }.shadow(radius: 5)
                    
                    if zoomSegment == false{ // OROLOGIO
                        AnalogClockView(zoomSegment: $zoomSegment).environmentObject(timeModel)
                    }
                    else{ // ZOOM
                        ZoomView()
                    }
                }
            }
    }
}

#Preview {
    ClockView()
}
