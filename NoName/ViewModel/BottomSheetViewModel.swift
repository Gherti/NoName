//
//  BottomSheetViewModel.swift
//  NoName
//
//  Created by Nicoló Metani on 17/03/25.
//

import SwiftUI

class TimeViewModel: ObservableObject {
    @Published var minuteStart: Double = 12
    @Published var minuteFinish: Double = 30
    
    // Funzione per aggiornare l'ora e i minuti
    func updateTimeStart(from orario: Date){
        let calendar = Calendar.current
        self.minuteStart = Double(calendar.component(.minute, from: orario) + calendar.component(.hour, from: orario)*60)
    }
    
    func updateTimeFinish(from orario: Date){
        let calendar = Calendar.current
        self.minuteFinish = Double(calendar.component(.minute, from: orario) + calendar.component(.hour, from: orario)*60)
    }
    
    func getMinuteStart() -> Double{
        return self.minuteStart
    }
    
    func getMinuteFinish() -> Double{
        return self.minuteFinish
    }
    
}
