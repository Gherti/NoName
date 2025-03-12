//
//  ClockView.swift
//  NoName
//
//  Created by Nicoló Metani on 10/03/25.
//

import SwiftUI

struct ClockView: View {
    var body: some View {
        NavigationView {
            VStack{
                ZStack(){
                    Color(.sRGB, red: 142/255, green: 202/255, blue: 230/255).ignoresSafeArea(.all)
                    
                    VStack{
                        HStack{
                            Text("Clock").padding().font(.system(size: 30, weight: .bold, design: .default))
                            Spacer()
                            Image(systemName: "plus.circle").resizable().frame(width:
                                                                                40.0, height: 40.0).padding()
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: "circle.lefthalf.filled.inverse").resizable().frame(width: 40.0, height: 40.0).padding().padding(.bottom, 60.0)
                            
                        }
                    }.shadow(radius: 5)
                    ZStack {
                        
                        Circle().fill(.white)
                        ToDoView()
                        Circle().strokeBorder(lineWidth: 4)
                    }.frame(width: 390, height: 390)
                    ZStack {
                        Circle().fill(Color(.sRGB, red: 142/255, green: 202/255, blue: 230/255))
                        Circle()
                            .stroke(lineWidth: 5)
                        ForEach(0..<60) { tick in
                            VStack {
                                Rectangle()
                                    .fill(.primary)
                                    .opacity(1)
                                    .frame(width: 2, height: tick % 5 == 0 ? 15 : 7)
                                Spacer()
                            }
                            .rotationEffect(.degrees(Double(tick)/60 * 360))
                        }
                        
                        ForEach(1..<13) { tick in
                            VStack {
                                Text("\(tick)")
                                    .font(.title)
                                    .rotationEffect(.degrees(-Double(tick)/12 * 360))
                                Spacer()
                            }
                            .rotationEffect(.degrees(Double(tick)/12 * 360))
                        }
                        .padding(20)
                    }.frame(width: 320, height: 320)
                    
                }
            }
        }
    }
}

#Preview {
    ClockView()
}
