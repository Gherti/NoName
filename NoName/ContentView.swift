//
//  ContentView.swift
//  NoName
//
//  Created by Nicoló Metani on 06/03/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
            VStack{
                
                HStack{
                    Color(.sRGB, red: 102/255, green: 122/255, blue: 176/255).shadow(radius: 10)
                }.ignoresSafeArea(.all)
                    .padding(.bottom,245)
                
                
                ZStack{
                    
                    Color(.white)
                    
                    VStack{
                        HStack{
                        
                            Image(systemName: "plus.app.fill").frame(alignment: .topTrailing)
                        }
                        Circle().strokeBorder(Color.black, lineWidth: 40)
                    }
                }
                
                ZStack{
                    Color(.sRGB, red: 102/255, green: 122/255, blue: 176/255).shadow(radius: 15)
                    HStack{
                        Image(systemName: "clock.fill").resizable().frame(width: 37.0, height: 37.0)
                        
                        Image(systemName: "calendar")
                            .resizable().frame(width: 37.0, height: 37.0).padding(.horizontal, 75)
                        
                        Image(systemName: "person.fill").resizable().frame(width: 37.0, height: 37.0)
                    }
                }.ignoresSafeArea(.all)
                    .padding(.top,200)
                    
            }
            
    }
        
        
}


#Preview {
    ContentView()
}
