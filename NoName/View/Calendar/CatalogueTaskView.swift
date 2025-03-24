
import SwiftUI

struct CatalogueTaskView: View {
    @EnvironmentObject var toDoModel: ToDoModel
    @EnvironmentObject var dateModel: DateModel
    @Environment(\.modelContext) var context
    
    var tasksForSelectedDate: [Task] {
        toDoModel.getTasks(selectedDate: dateModel.selectedDate)
            .sorted { $0.startTime < $1.startTime }
    }
    
    
    func formatTime(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" // Cambia formato se necessario
        return dateFormatter.string(from: date)
    }
    
    var body: some View {
        HStack {
            VStack{
                ForEach(tasksForSelectedDate, id: \.id) { task in
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 280, height: 100).padding()
                            .foregroundColor(Color.gray)
                        
                        RoundedRectangle(cornerRadius: 7)
                            .frame(width: 50 ,height: 4) // Spessore della linea
                            .foregroundColor(.red) // Colore della linea
                            .offset(x: -150, y: -50)
                        Text(formatTime(from: task.startTime))
                            .offset(x: -150, y: -60)
                        
                        RoundedRectangle(cornerRadius: 7)
                            .frame(width: 50 ,height: 4) // Spessore della linea
                            .foregroundColor(.red) // Colore della linea
                            .offset(x: 150, y: 50)
                        Text(formatTime(from: task.endTime))
                            .offset(x: 150, y: 60)
                    }
                }
                Spacer()
            }
        }.onAppear {
            toDoModel.fetchTasks(context: context)
        }
    }
}

#Preview {
    CatalogueTaskView()
        .environmentObject(DateModel())
        .environmentObject(TimeModel())
        .environmentObject(ToDoModel()) 
}
