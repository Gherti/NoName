//
//  DateModel.swift
//  NoName
//
//  Created by Nicoló Metani on 21/03/25.
//

import Foundation

class DateModel: ObservableObject {
    @Published var selectedDate: (year: Int, month: Int, day: Int)? = nil
    
    
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
}
