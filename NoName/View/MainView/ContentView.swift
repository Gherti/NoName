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
                    ClockView().overlay(
                        Group {
                            if dateModel.viewTaskInfo {
                                Color.black.opacity(0.5)
                                    .ignoresSafeArea()
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            dateModel.viewTaskInfo = false
                                        }
                                    }
                                
                                TaskInfoView()
                                    .frame(width: 300, height: 450)
                                    .transition(.move(edge: .bottom))
                            }
                        }
                    )
                case 1:
                    CalendarView()
                default:
                    AdminView()
                }
            }
            Spacer(minLength: 3)
            ZStack {
                Color(.sRGB, red: 255/255, green: 183/255, blue: 3/255).ignoresSafeArea()
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
                                        .font(.system(size: 30))
                                        .foregroundStyle(.black)
                                }
                                else {
                                    Image(systemName: icons[number])
                                        .font(.system(size: 30))
                                        .foregroundStyle(.black)
                                }
                            }
                            else{
                                Image(systemName: icons[number])
                                    .font(.system(size: 30))
                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                        })
                    }
                }.padding(.top, 5)
            }.frame(height: 55)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(DateModel())
        .environmentObject(TimeModel())
        .environmentObject(TaskModel()) 
}
