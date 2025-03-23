//
//  CatalogueTaskView.swift
//  NoName
//
//  Created by Leonardo Ghimenti on 23/03/25.
//

import SwiftUI

struct CatalogueTaskView: View {
    @EnvironmentObject var toDoModel: ToDoModel
    @EnvironmentObject var dateModel: DateModel
    @Environment(\.modelContext) var context
    
    var tasksForSelectedDate: [Task] {
        toDoModel.getTasks(selectedDate: dateModel.selectedDate)
    }
    var body: some View {
        VStack{
            ForEach(tasksForSelectedDate, id: \.id) { task in
                Text("\(task.startTime), \(task.endTime), \(task.startDate) , \(task.endDate)")
            }
        }.onAppear {
            toDoModel.fetchTasks(context: context)
        }
    }
}

#Preview {
    CatalogueTaskView()
        .environmentObject(DateModel())
        .environmentObject(ToDoModel())
}
