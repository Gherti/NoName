import Foundation
import SwiftUI

class TimeModel: ObservableObject {
    @Published var showClock: Bool = false
    
    func toggleClock() {
        showClock.toggle()
    }
    
    //BottomSHeetView
    
    func timeGreater(startTime: Date, endTime: Date, startDate: Date, endDate: Date) -> Bool {
        let calendar = Calendar.current
        
        // Normalizziamo le date rimuovendo il tempo (ore, minuti, secondi)
        let startDateNormalized = calendar.startOfDay(for: startDate)
        let endDateNormalized = calendar.startOfDay(for: endDate)
        
        // Confrontiamo le date (senza orari)
        if startDateNormalized > endDateNormalized {
            return true  // Invalid: end date is before start date
        }
        
        // Se le date sono uguali, confrontiamo gli orari
        if startDateNormalized == endDateNormalized {
            let startComponents = calendar.dateComponents([.hour, .minute], from: startTime)
            let endComponents = calendar.dateComponents([.hour, .minute], from: endTime)
            
            guard let startHour = startComponents.hour,
                  let startMinute = startComponents.minute,
                  let endHour = endComponents.hour,
                  let endMinute = endComponents.minute else {
                return true  // If we can't extract components, consider it invalid
            }
            
            // Confronto degli orari
            if startHour > endHour {
                return true
            }
            
            if startHour == endHour && startMinute >= endMinute {
                return true
            }
        }
        
        return false
    }
    
    
    func setSecondZero(date: Date) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        components.second = 0  // Imposta i secondi a zero senza toccare il resto
        return calendar.date(from: components) ?? date
    }
    
    func taskSize(_ task: Task) -> (startAng: Angle, endAng: Angle) {
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let start = calendar.startOfDay(for: task.startDateTime)
        let end = calendar.startOfDay(for: task.endDateTime)
        
        let startMinutes = calendar.component(.hour, from: task.startDateTime) * 60 +
                           calendar.component(.minute, from: task.startDateTime)
        let endMinutes = calendar.component(.hour, from: task.endDateTime) * 60 +
                         calendar.component(.minute, from: task.endDateTime)
        
        var startAng: Double = 0.0
        var endAng: Double = 0.0
        
        if today < start || today > end {
            
            return (.degrees(0), .degrees(0)) // Task non in corso oggi
        }
        
        
        if today == start {
            startAng = Double(startMinutes)
        } else {
            startAng = 0.0 // Se il task è già iniziato nei giorni precedenti
        }
        
        if today == end {
            endAng = Double(endMinutes)
        } else {
            endAng = 1440.0 // Se il task finisce in giorni successivi
        }
        
        // Mostrare solo la metà del cerchio corretta per AM/PM
        let showPM = showClock
        let correctedStart = showPM ? max(startAng, 720) : min(startAng, 720)
        let correctedEnd = showPM ? max(endAng, 720) : min(endAng, 720)
        return (.degrees(correctedStart * 0.5 - 90), .degrees(correctedEnd * 0.5 - 90))
    }

}
