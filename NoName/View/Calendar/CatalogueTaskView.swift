import SwiftUI

struct CatalogueTaskView: View {
    @EnvironmentObject var taskModel: TaskModel
    @EnvironmentObject var dateModel: DateModel
    @Environment(\.modelContext) var context
    
    var tasksForSelectedDate: [Task] {
        taskModel.getTasks(selectedDate: dateModel.selectedDate)
            .sorted { $0.startDateTime < $1.startDateTime }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(tasksForSelectedDate, id: \.id) { task in
                    let (startTimeString,endTimeString) = dateModel.dateSize(task.startDateTime,  task.endDateTime, task)
                    let height = dateModel.dateHeight(start: startTimeString, end: endTimeString)
                    ZStack {
                        Button(action: {
                            withAnimation(.bouncy){
                                dateModel.seeTaskInfo(taskSelected: task)
                            }
                        }){
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: 280, height: height)
                                .padding()
                                .foregroundColor(Color.red)
                                .overlay(
                                    VStack(alignment: .leading, spacing: 5) {
                                        if height >= 10 {
                                            Text("\(task.name)")
                                                .foregroundColor(.white.opacity(0.8))
                                                .font(.system(size: min(height * 0.8, 24)))
                                                .lineLimit(1)
                                        }
                                        if height >= 55 {
                                            Text("\(task.location)") // Corretto il nome della variabile
                                                .foregroundColor(.white.opacity(0.8))
                                                .font(.system(size: 16))
                                                .lineLimit(1)
                                        }
                                    }
                                        .padding(.leading, 20)
                                        .padding(.top, 15),
                                    alignment: .topLeading
                                )
                        }
                    
                        // Linee e orari
                        RoundedRectangle(cornerRadius: 7)
                            .frame(width: 350, height: 1)
                            .foregroundColor(.gray.opacity(0.7))
                            .offset(x: 0, y: -height / 2)
                        Text(startTimeString)
                            .offset(x: -157, y: -(height / 2 + 10))
                            .foregroundColor(.gray.opacity(0.7))
                            .fontWeight(.bold)
                        
                        RoundedRectangle(cornerRadius: 7)
                            .frame(width: 350, height: 1)
                            .foregroundColor(.gray.opacity(0.7))
                            .offset(x: 0, y: height / 2)
                        Text(endTimeString)
                            .offset(x: 157, y: height / 2 + 10)
                            .foregroundColor(.gray.opacity(0.7))
                            .fontWeight(.bold)
                        
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            /*.onAppear {
                taskModel.fetchTasks(context: context)
            }*/
        }
        .frame(maxWidth: .infinity)
        .scrollIndicators(.hidden)
        .background(Color.black)
    }
}

#Preview {
    CatalogueTaskView()
        .environmentObject(DateModel())
        .environmentObject(TimeModel())
        .environmentObject(TaskModel())
}
