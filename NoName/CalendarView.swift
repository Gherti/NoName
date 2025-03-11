//
//  CalendarView.swift
//  NoName
//
//  Created by Nicoló Metani on 10/03/25.
//

import SwiftUI

struct CalendarView: View {
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Color(.sRGB, red: 142/255, green: 202/255, blue: 230/255).ignoresSafeArea(.all)
                    VStack{
                        HStack{
                            Text("Calendar").padding().font(.system(size: 30, weight: .bold, design: .default))
                            Spacer()
                            Image(systemName: "plus.circle").resizable().frame(width:
                                                                                40.0, height: 40.0).padding()
                        }
                        Spacer()
                        
                        
                    }.shadow(radius: 3)
                }
            }
        }
    }
}

#Preview {
    CalendarView()
}
