
import SwiftUI

struct CatalogueTaskView: View {
    
    @EnvironmentObject var toDoModel: ToDoModel
    @EnvironmentObject var dateModel: DateModel
    
    @Environment(\.modelContext) var context
    
    var tasksForSelectedDate: [Task] {
        toDoModel.getTasks(selectedDate: dateModel.selectedDate)
            .sorted { $0.startTime < $1.startTime }
    }
    
    var body: some View {
        ScrollView {
            VStack{
                ForEach(tasksForSelectedDate, id: \.id) { task in
                    let height = dateModel.getSizeDate(start: task.startTime, end: task.endTime)
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 280, height: height).padding()
                            .foregroundColor(Color.gray)
                        
                        RoundedRectangle(cornerRadius: 7)
                            .frame(width: 50 ,height: 4) // Spessore della linea
                            .foregroundColor(.red) // Colore della linea
                            .offset(x: -150, y: -height/2)
                        Text(dateModel.formatTime(from: task.startTime))
                            .offset(x: -150, y: -(height/2 + 10))
                        
                        RoundedRectangle(cornerRadius: 7)
                            .frame(width: 50 ,height: 4) // Spessore della linea
                            .foregroundColor(.red) // Colore della linea
                            .offset(x: 150, y: height/2)
                        Text(dateModel.formatTime(from: task.endTime))
                            .offset(x: 150, y: height/2 + 10)
                    }
                }
                Spacer()
            }.frame(maxWidth: .infinity)
            .onAppear {
                        toDoModel.fetchTasks(context: context)
            }
        }.frame(maxWidth: .infinity)
            .scrollIndicators(.hidden)
    }
}

#Preview {
    CatalogueTaskView()
        .environmentObject(DateModel())
        .environmentObject(TimeModel())
        .environmentObject(ToDoModel()) 
}
