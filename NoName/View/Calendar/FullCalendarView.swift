
import SwiftUI

struct FullCalendarView: View {
    @EnvironmentObject var dateModel: DateModel
    
    @State private var isSheetPresented = false
    @State private var currentDay: Int = Calendar.current.component(.day, from: Date())
    @State private var currentMonth: Int = Calendar.current.component(.month, from: Date())
    @State private var currentYear: Int = Calendar.current.component(.year, from: Date())
    
    
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    var body: some View {
        VStack {
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    ForEach(1...12, id: \.self) { month in
                        HStack {
                            Text(dateModel.months[month - 1])
                                .padding()
                                .font(.system(size: 30, weight: .bold, design: .rounded))
                                .foregroundStyle(.white.opacity(0.8))
                                
                            Spacer()
                        }
                        .id(month) // Imposta l'ID per il mese
                        
                        HStack {
                            ForEach(dateModel.daysOfWeek.indices, id: \.self) { index in
                                Text(dateModel.daysOfWeek[index])
                                    .foregroundStyle(.white)
                                    .opacity(0.9)
                                    .font(.system(size: 20, weight: .medium, design: .rounded))
                                    .padding(8)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        
                        VStack {
                            let days = dateModel.days(year: currentYear, month: month)
                            LazyVGrid(columns: columns) {
                                ForEach(Array(days.enumerated()), id: \.offset) { index, day in
                                    if day == 0 {
                                        Text("")
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    } else {
                                        /*if currentDay == day && currentMonth == month{
                                         Circle()
                                         }*/
                                        Button(action: {
                                            dateModel.selectDate(year: currentYear, month: month, day: day)
                                            isSheetPresented.toggle()
                                        }) {
                                            ZStack{
                                                if day == currentDay && month == currentMonth{
                                                    Circle().fill(Color.red).frame(width:35, height:35)
                                                }
                                                Text("\(day)")
                                                    .font(.system(size: 20, weight: .light, design: .rounded))
                                                    .padding(8)
                                                    .foregroundStyle(.white)
                                            }
                                        }.sheet(isPresented: $isSheetPresented){
                                            BottomDayView()
                                        }.onChange(of: isSheetPresented) {
                                            if !isSheetPresented{
                                                dateModel.viewTaskInfo = false
                                            }
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                    .onAppear {
                        // Scorri automaticamente al mese corrente
                        scrollViewProxy.scrollTo(currentMonth, anchor: .top)
                    }
                }
            }
        }.background(Color.black.opacity(0.9))
    }
}

#Preview {
    FullCalendarView()
        .environmentObject(DateModel())
        .environmentObject(TimeModel())
        .environmentObject(TaskModel()) 
}
