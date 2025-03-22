//
//  BotttomSheetView.swift
//  NoName
//
//  Created by Nicoló Metani on 17/03/25.
//

import SwiftUI
import SwiftData

struct BotttomSheetView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    //Oggetti provenienti da fuori
    @State private var task = Task()
    @EnvironmentObject var toDoModel: ToDoModel
    
    func timeGreater(startTime: Date , endTime: Date, startDate: Date, endDate: Date) -> Bool {
        let calendar = Calendar.current
        
        let time = Double(calendar.component(.minute, from: startTime) + calendar.component(.hour, from: startTime)*60) >= Double(calendar.component(.minute, from: endTime) + calendar.component(.hour, from: endTime)*60)
        
        if startDate > endDate{
            return true
        }
        else if  startDate == endDate{
            if time{
                return true
            }
            else{
                return false
            }
        }
        return false
    }
    
    
    var body: some View {
        VStack{
            RoundedRectangle(cornerRadius: 4)
                            .frame(width: 40, height: 5)
                            .foregroundColor(Color.gray.opacity(0.5))
                            .padding(.top, 8)
            HStack{
                
                Button(action: {
                    dismiss()
                }){
                    Text("Cancel").padding([.leading, .bottom, .trailing])
                        .font(.system(size: 22, weight: .semibold)).foregroundStyle(.red)
                }
                
                Spacer()
                
                Button(action: {
                    if toDoModel.addTaskIfPossible(task, context: context) {
                                        dismiss()
                    }
                    else{
                        print("Task non aggiunto")
                    }
                    
                }){
                    Text("Add").padding([.leading, .bottom, .trailing])
                    .font(.system(size: 22, weight: .semibold))}.disabled(timeGreater(startTime: task.startTime, endTime: task.endTime, startDate: task.startDate, endDate: task.endDate))
                
            }
            GroupBox{
                GroupBox {
                    TextField("Nome", text:$task.name).foregroundStyle(.black)
                }
                GroupBox {
                    TextField("Luogo", text:$task.luogo).foregroundStyle(.black)
                }
            }.padding()
            GroupBox{
                HStack {
                    Text("Start")
                        .padding(.leading)
                    Spacer()
                    ZStack {
                        DatePicker("", selection: $task.startDate, displayedComponents: .date)
                            .padding(.trailing, 80.0)
                        DatePicker("", selection: $task.startTime, displayedComponents: .hourAndMinute)
                    }
                }.padding(10.0)
                
                HStack {
                    Text("End")
                        .padding(.leading)
                    Spacer()
                    ZStack {
                        DatePicker("", selection: $task.endDate, displayedComponents: .date)
                            .padding(.trailing, 80.0)
                        DatePicker("", selection: $task.endTime, displayedComponents: .hourAndMinute)
                    }
                }.padding(10.0)
            }
            Spacer()
            
        }.onAppear{
            toDoModel.fetchTasks(context: context)
        }
    }
    
    
}

#Preview {
    BotttomSheetView().modelContainer(for: Task.self)
        .environmentObject(TimeModel())
        .environmentObject(ToDoModel())
        
}
