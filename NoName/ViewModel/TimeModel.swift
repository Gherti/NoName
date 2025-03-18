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
}
