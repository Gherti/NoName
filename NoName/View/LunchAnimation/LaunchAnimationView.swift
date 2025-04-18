//
//  LaunchAnimationView.swift
//  NoName
//
//  Created by Nicoló Metani on 17/04/25.
//

import SwiftUI

struct LaunchAnimationView: View {
    @Binding var showMainView: Bool

        var body: some View {
            ClockAnimationView(showMainView: $showMainView)
                .onAppear {
                    // Dopo 4 secondi, mostra la TabView
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation {
                            showMainView = true
                        }
                    }
                }
        }
}

#Preview {
    LaunchAnimationView(showMainView: .constant(true))
}

