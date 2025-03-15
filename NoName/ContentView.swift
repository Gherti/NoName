//
//  CustomTabBar.swift
//  NoName
//
//  Created by  Metani on 10/03/25.
//

import SwiftUI

struct ContentView: View {
    @State var selectedIndex = 0
    
    let icons = [
        "clock",
        "calendar",
        "person"
    ]
    
    var body: some View {
        VStack{
            ZStack{
                switch selectedIndex {
                case 0:
                    ClockView()
                case 1:
                    CalendarView()
                default:
                    ProfileView()
                }
            }
            Spacer(minLength: 3)
            ZStack {
                Color(.sRGB, red: 255/255, green: 183/255, blue: 3/255).ignoresSafeArea(edges: .bottom).frame(height: 70)
                HStack{
                    ForEach(0..<3, id: \.self){number in
                        Button(action: {
                            self.selectedIndex = number
                        }, label:{
                            Spacer()
                            if selectedIndex == number {
                                if number != 1{
                                    Image(systemName: icons[number]+".fill")
                                        .font(.system(size: 40))
                                        .foregroundStyle(.black)
                                }
                                else {
                                    Image(systemName: icons[number])
                                        .font(.system(size: 40))
                                        .foregroundStyle(.black)
                                }
                            }
                            else{
                                Image(systemName: icons[number])
                                    .font(.system(size: 40))
                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                        })
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
