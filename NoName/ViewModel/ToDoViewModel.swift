//
//  ToDoViewModel.swift
//  NoName
//
//  Created by Nicoló Metani on 17/03/25.
//

import SwiftUI

class TaskViewModel: ObservableObject {
    @Published var amTasks: [(color: Color, value1: Double, value2: Double)] = []
    @Published var pmTasks: [(color: Color, value1: Double, value2: Double)] = []
    @Published var clockPresented: Bool = true
    
    func addTask(color: Color, value1: Double, value2: Double) {
        if value2 > 720{
            pmTasks.append((color: color, value1: value1, value2: value2))
        }
        else{
            amTasks.append((color: color, value1: value1, value2: value2))
        }
    }
    
    func getAmTasks() -> [(color: Color, value1: Double, value2: Double)] {
        return amTasks
    }
    
    func getPmTasks() -> [(color: Color, value1: Double, value2: Double)] {
        return pmTasks
    }
    
    func changeClockPresented() {
        clockPresented.toggle()
    }
}
