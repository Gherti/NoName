//
//  TimeModel.swift
//  NoName
//
//  Created by Nicoló Metani on 18/03/25.
//

import Foundation

class TimeModel: ObservableObject {
    @Published var showClock: Bool = false
    
    func toggleClock() {
        showClock.toggle()
    }
    
    //BottomSHeetView
    
    func setSecondZero(date: Date) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        components.second = 0  // Imposta i secondi a zero senza toccare il resto
        return calendar.date(from: components) ?? date
    }
    
    func timeGreater(startTime: Date , endTime: Date, startDate: Date, endDate: Date) -> Bool {
        
        let time = setSecondZero(date: startTime) >= setSecondZero(date: endTime)
        if startDate > endDate{
            return true
        }
        else if  startDate == endDate{
            if time{
                return true
            }
            else{
                return false
            }
        }
        return false
    }
}
