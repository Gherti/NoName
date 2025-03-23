//
//  NoNameApp.swift
//  NoName
//
//  Created by Nicoló Metani on 08/03/25.
//

import SwiftUI

@main
struct NoNameApp: App {
    @StateObject private var timeModel = TimeModel()
    @StateObject private var toDoModel = ToDoModel()
    @StateObject private var dateModel = DateModel()// Add this line
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dateModel)
                .environmentObject(timeModel)
                .environmentObject(toDoModel) // Add this line
                .modelContainer(for: Task.self)
        }
    }
}
//, inMemory: false, isUndoEnabled: true, onSetup: { container in
// This is where you'd handle migrations if needed
//print("SwiftData container setup complete")}
