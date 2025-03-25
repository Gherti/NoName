
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
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 280, height: height).padding()
                            .foregroundColor(Color.red)
                        
                        RoundedRectangle(cornerRadius: 7)
                            .frame(width: 350 ,height: 1) // Spessore della linea
                            .foregroundColor(.gray.opacity(0.5)) // Colore della linea
                            .offset(x: 0, y: -height/2)
                        Text(dateModel.formatTime(from: task.startTime))
                            .offset(x: -157, y: -(height/2 + 10))
                            .foregroundColor(.gray.opacity(0.5))
                            .fontWeight(.bold)
                        
                        RoundedRectangle(cornerRadius: 7)
                            .frame(width: 350 ,height: 1) // Spessore della linea
                            .foregroundColor(.gray.opacity(0.5)) // Colore della linea
                            .offset(x: 0, y: height/2)
                        Text(dateModel.formatTime(from: task.endTime))
                            .offset(x: 157, y: height/2 + 10)
                            .foregroundColor(.gray.opacity(0.5))
                            .fontWeight(.bold)
                    }
                }
                Spacer()
            }.frame(maxWidth: .infinity)
            .onAppear {
                        toDoModel.fetchTasks(context: context)
            }
            /*VStack{
            ForEach(1...3, id: \.self) { task in
                
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 280, height: 100).padding()
                        .foregroundColor(Color.red)
                    
                    RoundedRectangle(cornerRadius: 7)
                        .frame(width: 350 ,height: 1) // Spessore della linea
                        .foregroundColor(.gray.opacity(0.5)) // Colore della linea
                        .offset(x: 0, y: -50)
                    Text("9:00")
                        .foregroundStyle(.gray.opacity(0.5))
                        .offset(x: -156, y: -60)
                        .fontWeight(.bold)
                    
                    RoundedRectangle(cornerRadius: 7)
                        .frame(width: 350 ,height: 1)  // Spessore della linea
                        .foregroundColor(.gray.opacity(0.5)) // Colore della linea
                        .offset(x: 0, y: 50)
                    Text("10:00")
                        .foregroundStyle(.gray.opacity(0.5))
                        .offset(x: 157, y: 60)
                        .fontWeight(.bold)
                        
                }
            }
            Spacer()
        }*/
        }.frame(maxWidth: .infinity)
            .scrollIndicators(.hidden)
            .background(Color.black)
    }
}

#Preview {
    CatalogueTaskView()
        .environmentObject(DateModel())
        .environmentObject(TimeModel())
        .environmentObject(ToDoModel()) 
}
