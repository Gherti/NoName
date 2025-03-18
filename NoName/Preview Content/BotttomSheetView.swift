//
//  BotttomSheetView.swift
//  NoName
//
//  Created by Nicoló Metani on 17/03/25.
//

import SwiftUI

struct BotttomSheetView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    //Oggetti provenienti da fuori
    @State private var task = Task()
    
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
                    context.insert(task)
                    dismiss()
                }){
                    Text("Add").padding().font(.system(size: 25, weight: .bold, design: .default))}.disabled(task.start >= task.end ? true : false)
                
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
                DatePicker("Inizio", selection: $task.start, displayedComponents: .hourAndMinute).padding()
                
                DatePicker("Fine", selection: $task.end, displayedComponents: .hourAndMinute).padding()
            }.padding()
            Spacer()
            
        }
    }
    
    
}

#Preview {
    BotttomSheetView().modelContainer(for: Task.self)
        
}
