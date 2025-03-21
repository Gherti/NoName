//
//  CalendarView.swift
//  NoName
//
//  Created by Nicoló Metani on 10/03/25.
//

import SwiftUI

struct CalendarView: View {
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    let daysOfWeek = ["M","T","W","T","F","S","S"]
    var body: some View {
        VStack {
            ZStack {
                Color(.sRGB, red: 142/255, green: 202/255, blue: 230/255).ignoresSafeArea(.all)
                VStack{
                    HStack{
                        Text("Calendar").padding().font(.system(size: 30, weight: .bold, design: .default))
                        Spacer()
                        Image(systemName: "plus.circle").font(.system(size: 35))
                            .foregroundStyle(.black).padding()
                    }
                    HStack {
                        Text("January").padding().font(.system(size: 30, weight: .light, design: .default))
                        Spacer()
                        
                    }
                    HStack{
                        ForEach(daysOfWeek.indices, id: \.self) { index in
                                Text(daysOfWeek[index]).font(.system(size: 20, weight: .light, design: .default)).padding(8)
                                        .frame(maxWidth: .infinity)
                                }
                    }
                    VStack{
                        LazyVGrid(columns: columns) {
                            ForEach(1...30, id: \.self){ i in
                                Text("\(i)").font(.system(size: 20, weight: .light, design: .default)).padding(8)
                            }
                        }
                            
                    }
                    Spacer()
                }.shadow(radius: 3)
            }
        }
    }
}

#Preview {
    CalendarView()
}
