//
//  ContentView.swift
//  NoName
//
//  Created by Nicoló Metani on 06/03/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            VStack{
                ZStack{
                    Color(.sRGB, red: 102/255, green: 122/255, blue: 176/255).ignoresSafeArea(.all)
                    HStack{
                        Image(systemName: "clock.fill").resizable().frame(width: 37.0, height: 37.0)

                        
                        Image(systemName: "calendar").resizable().frame(width: 37.0, height: 37.0).padding(.horizontal, 75)
                        
                        Image(systemName: "person.fill").resizable().frame(width: 37.0, height: 37.0)
                    }
                }
            }
            
        }
            
    }
        
        
}


#Preview {
    ContentView()
}
