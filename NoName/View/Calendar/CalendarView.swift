import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var dateModel: DateModel
    @State private var isSheetPresented = false
    
    var body: some View {
        VStack {
            ZStack {
                Color(.sRGB, red: 142/255, green: 202/255, blue: 230/255).ignoresSafeArea(.all)
                VStack {
                    HStack {
                        Text("Calendar")
                            .padding()
                            .font(.system(size: 30, weight: .bold, design: .default))
                        Spacer()
                        Button(action:{
                            isSheetPresented.toggle()
                        }, label:{
                            Image(systemName: "plus.circle").font(.system(size: 35))
                                .foregroundStyle(.black).padding()
                        }).sheet(isPresented: $isSheetPresented){
                            BotttomSheetView()
                        }
                    }
                    FullCalendarView()
                    
                }
            }
        }
    }
}

#Preview {
    CalendarView()
        .environmentObject(DateModel())
        .environmentObject(TimeModel())
        .environmentObject(ToDoModel()) 
}
