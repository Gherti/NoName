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
                
                ZStack(alignment: .topTrailing){
                    Color(.white)
                    
                    HStack{
                        Image(systemName: "clock.fill").resizable().frame(width: 30.0, height: 30.0).padding()
                    }
                    Circle().strokeBorder(Color.black, lineWidth: 40).padding()

                }
                
                HStack{
                    Spacer()
                    Image(systemName: "clock.fill").resizable().frame(width: 37.0, height: 37.0)
                    Spacer()
                    Image(systemName: "calendar").resizable().frame(width: 37.0, height: 37.0)
                    Spacer()
                    Image(systemName: "person.fill").resizable().frame(width: 37.0, height: 37.0)
                    Spacer()
                }.padding(.top)
            }
        }
            
    }
        
        
}


#Preview {
    ContentView()
}
