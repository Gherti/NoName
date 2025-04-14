//
//  CustomTabBar.swift
//  NoName
//
//  Created by  Metani on 10/03/25.
//

import SwiftUI

struct ContentView: View {
    @State var selectedIndex = 0
    @EnvironmentObject var dateModel: DateModel
    
    var body: some View {
        
        TabView(selection: $selectedIndex) {
            Group{
                ClockView()
                    .tabItem {
                        Image(systemName: selectedIndex == 0 ? "clock.fill" : "clock")
                        Text("Clock")
                    }
                    .tag(0)
                
                CalendarView()
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Calendar")
                    }
                    .tag(1)
                
                AdminView()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Profile")
                    }
                    .tag(2)
            }
            .toolbarBackground(.black, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
        }
        .accentColor(.white)
        // cambia il colore dell’icona attiva
        .onChange(of: selectedIndex) {
            dateModel.viewTaskInfo = false
        }
        
        /*VStack{
            ZStack{
                switch selectedIndex {
                case 0:
                    ClockView()
                case 1:
                    CalendarView()
                default:
                    AdminView()
                }
            }
            Spacer(minLength: 3)
            ZStack {
                Color(.black)
                    .opacity(0.8)
                    .ignoresSafeArea()
                    
                HStack{
                    ForEach(0..<3, id: \.self){number in
                        Button(action: {
                            self.selectedIndex = number
                            dateModel.viewTaskInfo = false
                        }, label:{
                            Spacer()
                            if selectedIndex == number {
                                if number != 1{
                                    Image(systemName: icons[number]+".fill")
                                        .font(.system(size: 27))
                                        .foregroundStyle(.red)
                                }
                                else {
                                    Image(systemName: icons[number])
                                        .font(.system(size: 27))
                                        .foregroundStyle(.red)
                                }
                            }
                            else{
                                Image(systemName: icons[number])
                                    .font(.system(size: 27))
                                    .foregroundStyle(.red)
                            }
                            Spacer()
                        })
                    }
                }.padding(.top, 15)
            }.frame(height: 40)
        }*/
    }
}

#Preview {
    ContentView()
        .environmentObject(DateModel())
        .environmentObject(TimeModel())
        .environmentObject(TaskModel()) 
}
