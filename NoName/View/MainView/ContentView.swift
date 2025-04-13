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
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(DateModel())
        .environmentObject(TimeModel())
        .environmentObject(TaskModel()) 
}
