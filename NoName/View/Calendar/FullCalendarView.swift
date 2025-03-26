
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
                                .font(.system(size: 30, weight: .light, design: .default))
                            Spacer()
                        }
                        .id(month) // Imposta l'ID per il mese

                        HStack {
                            ForEach(dateModel.daysOfWeek.indices, id: \.self) { index in
                                Text(dateModel.daysOfWeek[index])
                                    .font(.system(size: 20, weight: .light, design: .default))
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
                                            dateModel.insertDate(year: 2025, month: month, day: day)
                                            isSheetPresented.toggle()
                                        }) {
                                            Text("\(day)")
                                                .font(.system(size: 20, weight: .light, design: .default))
                                                .padding(8)
                                                .foregroundStyle(.black)
                                        }.sheet(isPresented: $isSheetPresented){
                                            BottomDayView()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .onAppear {
                    // Scorri automaticamente al mese corrente
                    withAnimation {
                        scrollViewProxy.scrollTo(currentMonth, anchor: .top)
                    }
                }
            }
            Spacer()
        }
    }
}

#Preview {
    FullCalendarView()
        .environmentObject(DateModel())
        .environmentObject(TimeModel())
        .environmentObject(TaskModel()) 
}
