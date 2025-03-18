//
//  BotttomSheetView.swift
//  NoName
//
//  Created by Nicoló Metani on 17/03/25.
//

import SwiftUI

struct BotttomSheetView: View {
    @EnvironmentObject var timeViewModel: TimeViewModel
    @EnvironmentObject private var taskViewModel: TaskViewModel
    @State private var inizio =  Date()
    @State private var fine =  Date()
    
    var body: some View {
        VStack{
            HStack{
                Text("Cancel").padding().font(.system(size: 25, weight: .bold, design: .default))
                Spacer()
                Button(action: {
                    timeViewModel.updateTimeStart(from: inizio)
                    timeViewModel.updateTimeFinish(from: fine)
                    
                    //aggiunto ai task
                    taskViewModel.addTask(color: .red, value1: timeViewModel.getMinuteStart(), value2: timeViewModel.getMinuteFinish())
                    
                    
                }){
                    Text("Add").padding().font(.system(size: 25, weight: .bold, design: .default))}
                
            }
            Spacer()
            GroupBox{
                DatePicker("Inizio", selection: $inizio, displayedComponents: .hourAndMinute).padding()
                
                DatePicker("Fine", selection: $fine, displayedComponents: .hourAndMinute).padding()
            }.padding()
            Spacer()
            Spacer()
        }
    }
    
    
}

#Preview {
    BotttomSheetView()
}
