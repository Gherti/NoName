//
//  BottomSheetViewModel.swift
//  NoName
//
//  Created by Nicoló Metani on 17/03/25.
//

import SwiftUI

class TimeViewModel: ObservableObject {
    @Published var minuteStart: Int = 12
    @Published var minuteFinish: Int = 30
    
    // Funzione per aggiornare l'ora e i minuti
    func updateTimeStart(from orario: Date){
        let calendar = Calendar.current
        self.minuteStart = calendar.component(.minute, from: orario) + calendar.component(.hour, from: orario)*60
    }
    
    func updateTimeFinish(from orario: Date){
        let calendar = Calendar.current
        self.minuteFinish = calendar.component(.minute, from: orario) + calendar.component(.hour, from: orario)*60
    }
    
    func getMinuteStart() -> Int{
        return self.minuteStart
    }
    
    func getMinuteFinish() -> Int{
        return self.minuteFinish
    }
    
}
