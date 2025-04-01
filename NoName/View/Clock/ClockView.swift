import SwiftUI
import SwiftData

struct ClockView: View {
    @EnvironmentObject var timeModel: TimeModel
    @Environment(\.modelContext) var modelContext
    
    
    @State var zoomSegment: Bool = false
    @State private var isSheetPresented = false
    @State private var isDentsPresented: Bool = false
    
    
    
    var body: some View {
            ZStack{
                Color(.sRGB, red: 142/255, green: 202/255, blue: 230/255).ignoresSafeArea(.all)
                
                VStack{
                    HStack{
                        
                        //3 PUNTINI
                        Menu {
                            Button(action: {
                                isDentsPresented.toggle()
                                
                            }) {
                                
                                Label("Add Tag", systemImage: "tag")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .foregroundColor(.black)
                                .font(.system(size: 35))
                                .padding()
                        }
                        .sheet(isPresented: $isDentsPresented){
                            BottomTagView().presentationDetents([.medium])
                        }
                        
                        Spacer()
                        
                        //PULSTANTE +
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
                    //CAMBIO ARCO ORARIO
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
