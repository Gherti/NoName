//
//  NoNameApp.swift
//  NoName
//
//  Created by Nicoló Metani on 08/03/25.
//

import SwiftUI

@main
struct NoNameApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Task.self)
        }
        
    }
}
