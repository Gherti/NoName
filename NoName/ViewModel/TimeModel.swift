import Foundation
import SwiftUI

class TimeModel: ObservableObject {
    @Published var showClock: Bool = false
    
    init() {
            let currentHour = Calendar.current.component(.hour, from: Date())
            
            // Imposta showClock in base all'ora della giornata
            if currentHour >= 12 || currentHour <= 23 {
                // Se l'ora è tra 18:00 e 6:00, imposta showClock su true
                self.showClock = true
            } else {
                // Altrimenti, imposta showClock su false
                self.showClock = false
            }
        }
    
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
    
    
    func timeSize(_ task: Task) -> (startAng: Angle, endAng: Angle) {
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
        
        if correctedEnd == 0 && correctedStart == 0{
            return (.degrees(0), .degrees(0))
        }
        else if correctedEnd == 720 && correctedStart == 720{
            return (.degrees(0), .degrees(0))
        }
        
        return (.degrees(correctedStart * 0.5 - 90), .degrees(correctedEnd * 0.5 - 90))
    }

}
