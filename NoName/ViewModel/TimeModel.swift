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
       
        let startMinutes = Double(calendar.component(.hour, from: task.startDateTime) * 60 +
                           calendar.component(.minute, from: task.startDateTime))
        let endMinutes =  Double(calendar.component(.hour, from: task.endDateTime) * 60 +
                         calendar.component(.minute, from: task.endDateTime))
        
        var startAng: Double = 0.0
        var endAng: Double = 1440.0
        // First check if task is active on the selected day
        
        guard let rep = task.repetition else {
            if today < start || today > end {
                return (.degrees(0), .degrees(0)) // Task non in corso oggi
            }
            
            if today == start {
                startAng = startMinutes
            } else {
                startAng = 0.0 // Se il task è già iniziato nei giorni precedenti
            }
            
            if today == end {
                endAng = endMinutes
            } else {
                endAng = 1440.0 // Se il task finisce in giorni successivi
            }
            let showPM = showClock
            let correctedStart = showPM ? max(startAng, 720) : min(startAng, 720)
            let correctedEnd = showPM ? max(endAng, 720) : min(endAng, 720)
            return (.degrees(correctedStart * 0.5 - 90), .degrees(correctedEnd * 0.5 - 90))
        }
        
        
        switch rep.unit{
            case .day:
                if today>end{
                    var diffDay = calendar.dateComponents([.day], from:  start, to: today).day ?? 0
                    if diffDay % rep.interval == 0{
                        startAng = startMinutes
                    }
                    
                    diffDay = calendar.dateComponents([.day], from: end, to: today).day ?? 0
                    if diffDay % rep.interval == 0{
                        endAng = endMinutes
                    }
                }else{
                    if start == today{
                        startAng = startMinutes
                    }
                    if end == today{
                        endAng = endMinutes
                    }
                }
            case .week:
                if today>end{
                    var diffDay = calendar.dateComponents([.day], from: start, to: today).day ?? 0
                    if diffDay % (rep.interval*7) == 0{
                        startAng = startMinutes
                    }
                    diffDay = calendar.dateComponents([.day], from: end, to: today).day ?? 0
                    
                    if diffDay % (rep.interval*7) == 0{
                        endAng = endMinutes
                    }
                }else{
                    if start == today{
                        startAng = startMinutes
                    }
                    if end == today{
                        endAng = endMinutes
                    }
                }
                
            
            case .month:
                    var diffMonth = calendar.dateComponents([.month], from: start, to: today).month ?? 0
                    let diffSnE = calendar.dateComponents([.month], from: start, to: end).month ?? 0
            
                    if calendar.component(.day, from: today) == calendar.component(.day, from: start) && diffMonth % rep.interval == 0{
                        startAng = today > end ? (rep.interval == diffSnE && calendar.component(.day, from: start) == calendar.component(.day, from: end) ? 0 : startMinutes) : (start == today ? startMinutes : 0)
                    }
            
                    diffMonth = calendar.dateComponents([.month], from:  end, to: today).month ?? 0
            
                    if calendar.component(.day, from: today) == calendar.component(.day, from: end) && diffMonth % rep.interval == 0{
                        endAng = today > end ? (rep.interval == diffSnE && calendar.component(.day, from: start) == calendar.component(.day, from: end) ? 1440 : endMinutes) : (
                            rep.interval == diffSnE && calendar.component(.day, from: start) == calendar.component(.day, from: end) ? 1440 : ( end == today ? endMinutes : 1440))
                    }
            
            case .year:
                    var diffMonth = calendar.dateComponents([.month], from: start, to: today).month ?? 0
                    let diffSnE = calendar.dateComponents([.month], from: start, to: end).month ?? 0
                    
                    if calendar.component(.day, from: today) == calendar.component(.day, from: start) && diffMonth % (rep.interval*12) == 0{
                        startAng = today > end ? (rep.interval*12 == diffSnE && calendar.component(.day, from: start) == calendar.component(.day, from: end) ? 0 : startMinutes) : (start == today ? startMinutes : 0)
                    }
            
                    diffMonth = calendar.dateComponents([.month], from:  end, to: today).month ?? 0
                    
                    if calendar.component(.day, from: today) == calendar.component(.day, from: end) && diffMonth % (rep.interval*12) == 0{
                        endAng = today > end ? (rep.interval*12 == diffSnE && calendar.component(.day, from: start) == calendar.component(.day, from: end) ? 1440 : endMinutes) : (
                            rep.interval*12 == diffSnE && calendar.component(.day, from: start) == calendar.component(.day, from: end) ? 1440 : ( end == today ? endMinutes : 1440))
                    }
        }
        
        let showPM = showClock
        let correctedStart = showPM ? max(startAng, 720) : min(startAng, 720)
        let correctedEnd = showPM ? max(endAng, 720) : min(endAng, 720)
        return (.degrees(correctedStart * 0.5 - 90), .degrees(correctedEnd * 0.5 - 90))
    }

}
