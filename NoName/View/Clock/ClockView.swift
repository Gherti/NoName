import SwiftUI
import SwiftData




struct ClockView: View {
    @EnvironmentObject var timeModel: TimeModel
    @EnvironmentObject var dateModel: DateModel
    @Environment(\.modelContext) var modelContext
    
    
    @State var zoomSegment: Bool = false
    @State private var isSheetPresented = false
    @State private var isDentsPresented: Bool = false
    
    
    
    var body: some View {
        ZStack{
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
                            .foregroundStyle(Color("Button"))
                            .font(.system(size: 30))
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
                        Image(systemName: "plus.circle").font(.system(size: 30))
                            .foregroundStyle(Color("Button"))
                            .padding()
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
                        Text(timeModel.showClock ? "PM" : "AM")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundStyle(timeModel.showClock ? Color.blue : .yellow)
                            .opacity(0.9)
                            .padding()
                            .padding(.bottom, 60.0)
                    }
                }
            }
            
            AnalogClockView(zoomSegment: $zoomSegment).overlay(
                Group {
                    
                    if dateModel.viewTaskInfo {
                        Color.black.opacity(0.5)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    dateModel.viewTaskInfo = false
                                }
                            }
                        TaskInfoView()
                            .frame(width: 300, height: 450)
                            .transition(.move(edge: .bottom))
                    }
                }
            )
        }.background(Color("Background"))
    }
}




#Preview {
    ClockView()
        .environmentObject(DateModel())
        .environmentObject(TimeModel())
        .environmentObject(TaskModel()) 
}
