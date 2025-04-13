import SwiftUI
import SwiftData
import Combine

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

struct ClockView: View {
    @EnvironmentObject var timeModel: TimeModel
    @Environment(\.modelContext) var modelContext
    @ObservedObject var currentTime = CurrentTime()
    
    @State var zoomSegment: Bool = false
    @State private var isSheetPresented = false
    @State private var isDentsPresented: Bool = false
    
    
    
    var body: some View {
            ZStack{
                Color(.black)
                    .opacity(0.9)
                    .ignoresSafeArea(.all)
                
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
                                .foregroundStyle(.red)
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
                                .foregroundStyle(.red)
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
                            Image(systemName: timeModel.showClock ? "moon.fill" : "sun.max.fill").font(.system(size: 35))
                                .foregroundStyle(.red).padding().padding(.bottom, 60.0)
                            
                        }
                    }
                }.shadow(radius: 5)
                
                AnalogClockView(zoomSegment: $zoomSegment)
                
                Hand(angleMultipler: currentTime.seconds / (60 * 12) / 60, scale: 0.5)
                    .stroke(.white, lineWidth: 4)
                // minute
                Hand(angleMultipler:  currentTime.seconds/60 / 60, scale: 0.6)
                    .stroke(.white, lineWidth: 2)
                // second
                Hand(angleMultipler: currentTime.seconds.remainder(dividingBy: 60) / 60, scale: 0.7)
                    .stroke(.red, lineWidth: 1)
                
                
                Circle()
                    .fill(.white)
                    .frame(width: 8, height: 8)
                Circle()
                    .fill(.white)
                    .frame(width: 4, height: 4)
            }
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
    ClockView()
        .environmentObject(DateModel())
        .environmentObject(TimeModel())
        .environmentObject(TaskModel()) 
}
