import SwiftUI

struct TaskInfoView: View {
    
    @EnvironmentObject var dateModel: DateModel
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button(action: {
                    dateModel.viewTaskInfo = false
                }){
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 25))
                        .foregroundStyle(.white.opacity(0.8))
                        .padding(10)
                }
            }
            
            if let task = dateModel.task {
                Text("Name: \(task.name)").foregroundStyle(.black.opacity(0.8)).padding(10)
                Text("Location: \(task.location)").foregroundStyle(.black.opacity(0.8)).padding(10)
                Text("Start: \(dateModel.formatTime(from: task.startDateTime))").foregroundStyle(.black.opacity(0.8)).padding(10)
                Text("End: \(dateModel.formatTime(from: task.startDateTime))").foregroundStyle(.black.opacity(0.8)).padding(10)
            } else {
                Text("Nessun task selezionato")
            }
            
            Spacer()
        }
    }
}

#Preview {
    TaskInfoView()
        .environmentObject(DateModel())
        .environmentObject(TimeModel())
        .environmentObject(TaskModel())
}
