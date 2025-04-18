import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var dateModel: DateModel
    @State private var isSheetPresented = false
    
    var body: some View {
          
        VStack {
            HStack {
                Text("Calendar")
                    .padding()
                    .font(.system(size: 25, weight: .bold, design: .default))
                    .foregroundStyle(Color("Button"))
                Spacer()
                Button(action:{
                    isSheetPresented.toggle()
                }, label:{
                    Image(systemName: "plus.circle").font(.system(size: 30))
                        .foregroundStyle(Color("Button"))
                        .padding()
                }).sheet(isPresented: $isSheetPresented){
                    BotttomSheetView()
                }
            }
            Spacer()
            FullCalendarView()
            
        }.background(Color("Background"))
    }
}

#Preview {
    CalendarView()
        .environmentObject(DateModel())
        .environmentObject(TimeModel())
        .environmentObject(TaskModel()) 
}
