import SwiftUI

struct ClockView: View {
    @StateObject private var timeViewModel = TimeViewModel()
    @StateObject private var taskViewModel = TaskViewModel()
    
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
                            }.environmentObject(timeViewModel).environmentObject(taskViewModel)
                            
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            
                            Button(action:{
                                taskViewModel.changeClockPresented()
                                print(taskViewModel.clockPresented)
                            }){
                                Image(systemName: taskViewModel.clockPresented ? "circle.lefthalf.filled" : "circle.lefthalf.filled.inverse").font(.system(size: 40))
                                        .foregroundStyle(.black).padding().padding(.bottom, 60.0)
                                
                            }
                        }
                    }.shadow(radius: 5)
                    
                    if zoomSegment == false{ // OROLOGIO
                        AnalogClockView(zoomSegment: $zoomSegment).environmentObject(taskViewModel)
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
