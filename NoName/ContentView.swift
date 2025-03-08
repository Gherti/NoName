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
            Color(.sRGB, red: 102/255, green: 122/255, blue: 176/255).ignoresSafeArea(.all)
            VStack{
                    Spacer()
                    HStack{
                        Image(systemName: "clock.fill").resizable().frame(width: 37.0, height: 37.0)

                        
                        Image(systemName: "calendar").resizable().frame(width: 37.0, height: 37.0).padding(.horizontal, 75)
                        
                        Image(systemName: "person.fill").resizable().frame(width: 37.0, height: 37.0)
                    }
            }
            VStack{
                
                ZStack{
                    Color(.white)
                    VStack{
                        Image(systemName: "clock.fill")
                    }
                    Circle().strokeBorder(Color.black, lineWidth: 40).padding()

                }
            }.padding(.bottom, 55)
            
        }
            
    }
        
        
}


#Preview {
    ContentView()
}
