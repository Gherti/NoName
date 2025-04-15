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
                    .foregroundStyle(.white.opacity(0.9))
                Spacer()
                Button(action:{
                    isSheetPresented.toggle()
                }, label:{
                    Image(systemName: "plus.circle").font(.system(size: 30))
                        .foregroundStyle(.white.opacity(0.9))
                        .padding()
                }).sheet(isPresented: $isSheetPresented){
                    BotttomSheetView()
                }
            }
            Spacer()
            FullCalendarView()
            
        }.background(Color.black.opacity(0.9))
    }
}

#Preview {
    CalendarView()
        .environmentObject(DateModel())
        .environmentObject(TimeModel())
        .environmentObject(TaskModel()) 
}
