import SwiftUI

struct TaskInfoView: View {
    @EnvironmentObject var dateModel: DateModel
    
    var body: some View {
        VStack {
            if let task = dateModel.task {
                    VStack(alignment: .leading, spacing: 15) {
                        infoRow(label: "Name", value: task.name)
                        infoRow(label: "Location", value: task.location)
                        infoRow(label: "Start", value: dateModel.formatTime(from: task.startDateTime))
                        infoRow(label: "End", value: dateModel.formatTime(from: task.endDateTime))
                    }
                    .padding()
            }
            else {
                Text("No task selected")
                    .foregroundStyle(.black.opacity(0.8))
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity) // This makes the background wider
        .background(Color.gray)
        .cornerRadius(20)
    }
    
    @ViewBuilder
    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text("\(label):")
                .font(.headline)
                .foregroundStyle(.black.opacity(0.6))
            
            Text(value)
                .font(.body)
                .foregroundStyle(.black.opacity(0.8))
        }
    }
}

#Preview {
    TaskInfoView()
        .environmentObject(DateModel())
        .environmentObject(TimeModel())
        .environmentObject(TaskModel())
}
