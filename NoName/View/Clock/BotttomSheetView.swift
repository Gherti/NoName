import SwiftUI
import SwiftData

struct BotttomSheetView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var contextt
    
    
    @State private var task = Task()
    
    @EnvironmentObject var taskModel: TaskModel
    @EnvironmentObject var timeModel: TimeModel
    
    @State private var endtime: Date = Date()
    @State private var starttime: Date = Date()
    
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
                    Text("Cancel")
                        .padding([.leading, .bottom, .trailing])
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.red)
                }
                
                Spacer()
                
                Button(action: {
                    // Reset the task state before adding
                    task.startDateTime = starttime
                    task.endDateTime = endtime
                    if !taskModel.checkTask(task){
                        print("Task Aggiunto")
                        taskModel.addTask(task: task, context: contextt)
                        dismiss()
                    }
                    else {
                        // Optionally, you could add error handling here
                        print("Task not added - potential overlap")
                    }
                }){
                    Text("Add")
                        .padding([.leading, .bottom, .trailing])
                        .font(.system(size: 22, weight: .semibold))
                }
                .disabled(timeModel.timeGreater(startTime: starttime, endTime: endtime, startDate: starttime, endDate: endtime))
            }
            
            Form {
               TextField("Nome", text: $task.name)
               TextField("Luogo", text: $task.location)
                   
                DatePicker("Inizio", selection: $starttime, displayedComponents: [.date, .hourAndMinute])
                
                DatePicker("Fine", selection: $endtime, displayedComponents: [.date, .hourAndMinute])
                
                Menu {
                    ForEach(taskModel.tags){tag in
                        Button(action: {
                            task.tag = tag
                        }) {
                            Text(tag.name)
                            Image(systemName: "tag.fill")
                                .foregroundStyle(Color(hex: tag.color), .primary)
                        }
                    }
                } label: {
                    HStack {
                        Text("Tag").foregroundStyle(.black)
                        Spacer()
                        Text(task.tag?.name ?? "Unselected").foregroundStyle(.gray)
                        Image(systemName: "chevron.up.chevron.down").foregroundStyle(.gray)
                    }
                 }
            }
        }
    }
}

#Preview {
    BotttomSheetView()
        .environmentObject(DateModel())
        .environmentObject(TimeModel())
        .environmentObject(TaskModel())
}
