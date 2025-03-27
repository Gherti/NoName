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
    
    //CALENDAR VIEW
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
    
    func insertDate(year: Int, month: Int, day: Int){
        selectedDate = (year: year, month: month, day: day)
    }
    
    func getDate()-> (year: Int, month: Int, day: Int)?{
        return selectedDate
    }
    
    //FullCalendarVIew e BottomDayView
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
    
    
    //BottomDayView
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
        withAnimation(.easeInOut(duration: 0.2)) {
            viewTaskInfo = false
        }

        insertDate(year: newYear, month: newMonth, day: newDay)
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
        withAnimation(.easeInOut(duration: 0.2)) {
            viewTaskInfo = false
        }

        insertDate(year: newYear, month: newMonth, day: newDay)
    }
    
    //CatalogueTaskView
    
    func formatTime(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" // Cambia formato se necessario
        return dateFormatter.string(from: date)
    }
    
    func dateHeight(start: Date, end: Date) -> Double {
        let calendar = Calendar.current
        return Double(calendar.component(.minute, from: end) + calendar.component(.hour, from: end) * 60) - Double(calendar.component(.minute, from: start) + calendar.component(.hour, from: start) * 60)
    }
    
    
    func seeTaskInfo(taskSelected: Task){
        viewTaskInfo.toggle()
        task = taskSelected
    }
    
}
