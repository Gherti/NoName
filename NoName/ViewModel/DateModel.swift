//
//  DateModel.swift
//  NoName
//
//  Created by Nicoló Metani on 21/03/25.
//

import Foundation
import SwiftUI
import SwiftData

class DateModel: ObservableObject {
    @Published var selectedDate: (year: Int, month: Int, day: Int)? = nil
    @Published var daysOfWeek = ["S", "M", "T", "W", "T", "F", "S"]
    @Published var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    @Published var viewTaskInfo: Bool = false
    @Published var task: Task? = nil
    
    //FullCalendar view
    func days(year: Int, month: Int) -> [Int]{
        let calendar = Calendar.current
        
        if let firstDayDate = calendar.date(from: DateComponents(year:year, month: month, day: 1)){
            
            let range = calendar.range(of: .day, in:.month, for: firstDayDate)
            
            let totalDays = range!.count
            let firstDay = calendar.component(.weekday, from: firstDayDate)
            
            let emptyDays = Array(repeating: 0, count: firstDay - 1)
            let days = Array(1...totalDays)
            
            return emptyDays + days
        }
        
        return []
    }
    
    //BottomDayView
    func getWeekdayName(year: Int, month: Int, day: Int) -> String? {
        let calendar = Calendar.current
        let components = DateComponents(year: year, month: month, day: day)

        if let date = calendar.date(from: components) {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US") // Lingua inglese
            formatter.dateFormat = "EEEE" // Nome completo del giorno

            return formatter.string(from: date) // "Monday", "Tuesday"...
        }
        
        return nil
    }
    
    func selectDate(year: Int, month: Int, day: Int){
        selectedDate = (year: year, month: month, day: day)
    }
    
    func nextDay() {
        guard let selectedDate = selectedDate else { return }
        
        var newYear = selectedDate.year
        var newMonth = selectedDate.month
        var newDay = selectedDate.day + 1
        
        let daysInMonth = days(year: newYear, month: newMonth).filter { $0 != 0 }.count
        
        if newDay > daysInMonth { // Se supera il numero di giorni nel mese, passa al mese successivo
            newDay = 1
            newMonth += 1
            if newMonth > 12 { // Se supera dicembre, passa all'anno successivo
                newMonth = 1
                newYear += 1
            }
        }
        if viewTaskInfo{
            withAnimation(.easeInOut(duration: 0.1)) {
                viewTaskInfo = false
            }
        }
        selectDate(year: newYear, month: newMonth, day: newDay)
    }
    
    func previousDay() {
        guard let selectedDate = selectedDate else { return }
        
        var newYear = selectedDate.year
        var newMonth = selectedDate.month
        var newDay = selectedDate.day - 1
        
        if newDay < 1 { // Se il giorno è minore di 1, passa al mese precedente
            newMonth -= 1
            if newMonth < 1 { // Se è minore di gennaio, torna a dicembre dell'anno precedente
                newMonth = 12
                newYear -= 1
            }
            let daysInPrevMonth = days(year: newYear, month: newMonth).filter { $0 != 0 }.count
            newDay = daysInPrevMonth
        }
        if viewTaskInfo{
            withAnimation(.easeInOut(duration: 0.1)) {
                viewTaskInfo = false
            }
        }

        selectDate(year: newYear, month: newMonth, day: newDay)
    }
    
    //CatalogueTaskView
    
    func formatTime(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" // Cambia formato se necessario
        return dateFormatter.string(from: date)
    }
    
    func dateHeight(start: String, end: String) -> Double {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        guard let startDate = dateFormatter.date(from: start),
              let endDate = dateFormatter.date(from: end) else {
            return 0.0
        }

        let calendar = Calendar.current
        let startMinutes = calendar.component(.hour, from: startDate) * 60 + calendar.component(.minute, from: startDate)
        let endMinutes = calendar.component(.hour, from: endDate) * 60 + calendar.component(.minute, from: endDate)

        return Double(endMinutes - startMinutes)
    }

    
    func dateSize(_ start: Date, _ end: Date) -> (String,String) {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = selectedDate?.year
        dateComponents.month = selectedDate?.month
        dateComponents.day = selectedDate?.day
        
        guard let date = calendar.date(from: dateComponents) else { return ("","") }
        
        let startTaskDate = calendar.startOfDay(for: start)
        let endTaskDate = calendar.startOfDay(for: end)
        let selectedDay = calendar.startOfDay(for: date)
        
        var startStr: String = ""
        var endStr: String = ""
        
        if startTaskDate < selectedDay && selectedDay < endTaskDate{
            startStr = "00:00"
            endStr = "23:59"
        }
        else if startTaskDate == selectedDay && selectedDay < endTaskDate{
            startStr = formatTime(from: start)
            endStr = "23:59"
        }
        else if startTaskDate < selectedDay && selectedDay == endTaskDate{
            endStr = formatTime(from: end)
            startStr = "00:00"
        }
        else if startTaskDate == selectedDay && selectedDay == endTaskDate{
            startStr = formatTime(from: start)
            endStr = formatTime(from: end)
        }
        
        return  (startStr,endStr)
    }
    
    
    
    func seeTaskInfo(taskSelected: Task){
        viewTaskInfo.toggle()
        task = taskSelected
    }
    
    
    
}
