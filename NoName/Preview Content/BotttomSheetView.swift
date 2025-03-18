//
//  BotttomSheetView.swift
//  NoName
//
//  Created by Nicoló Metani on 17/03/25.
//

import SwiftUI

struct BotttomSheetView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var timeViewModel: TimeViewModel
    @EnvironmentObject private var taskViewModel: TaskViewModel
    
    @State private var username: String = ""
    @State private var inizio =  Date()
    @State private var fine =  Date()
    
    var body: some View {
        VStack{
            HStack{
                
                Button(action: {
                    dismiss()
                }){
                    Text("Cancel").padding().font(.system(size: 25, weight: .bold, design: .default)).foregroundStyle(.black)
                }
                
                Spacer()
                Button(action: {
                    
                    timeViewModel.updateTimeStart(from: inizio)
                    timeViewModel.updateTimeFinish(from: fine)
                    
                    //aggiunto ai task
                    taskViewModel.addTask(color: .red, value1: timeViewModel.getMinuteStart(), value2: timeViewModel.getMinuteFinish())
                    dismiss()
                }){
                    Text("Add").padding().font(.system(size: 25, weight: .bold, design: .default))}.disabled(inizio >= fine ? true : false)
                
            }
            GroupBox{
                GroupBox {
                    TextField("Nome", text:$username).foregroundStyle(.black)
                }
                GroupBox {
                    TextField("Luogo", text:$username).foregroundStyle(.black)
                }
            }.padding()
            GroupBox{
                DatePicker("Inizio", selection: $inizio, displayedComponents: .hourAndMinute).padding()
                
                DatePicker("Fine", selection: $fine, displayedComponents: .hourAndMinute).padding()
            }.padding()
            Spacer()
            
        }
    }
    
    
}

#Preview {
    BotttomSheetView()
}
