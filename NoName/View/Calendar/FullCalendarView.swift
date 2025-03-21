//
//  FullCalendarView.swift
//  NoName
//
//  Created by Nicoló Metani on 21/03/25.
//

import SwiftUI

struct FullCalendarView: View {
    @EnvironmentObject var dateModel: DateModel
    @State private var currentMonth: Int = Calendar.current.component(.month, from: Date()) // mese corrente
    @State private var currentYear: Int = Calendar.current.component(.year, from: Date()) // anno corrente
    
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    let daysOfWeek = ["S", "M", "T", "W", "T", "F", "S"]
    let months = [
        "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var body: some View {
        VStack {
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    ForEach(1...12, id: \.self) { month in
                        HStack {
                            Text(months[month - 1])
                                .padding()
                                .font(.system(size: 30, weight: .light, design: .default))
                            Spacer()
                        }
                        .id(month) // Imposta l'ID per il mese

                        HStack {
                            ForEach(daysOfWeek.indices, id: \.self) { index in
                                Text(daysOfWeek[index])
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
                                        Button(action: {
                                            dateModel.insertDate(year: 2025, month: month, day: day)
                                        }) {
                                            Text("\(day)")
                                                .font(.system(size: 20, weight: .light, design: .default))
                                                .padding(8)
                                                .foregroundStyle(.black)
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
        .shadow(radius: 3)
    }
}

#Preview {
    FullCalendarView().environmentObject(DateModel())
}
