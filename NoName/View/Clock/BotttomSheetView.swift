import SwiftUI
import SwiftData

struct BotttomSheetView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var contextt

    @State private var task = Task()

    @EnvironmentObject var taskModel: TaskModel
    @EnvironmentObject var timeModel: TimeModel

    // Date pickers for start and end times
    @State private var starttime: Date = Date()
    @State private var endtime: Date = Date()

    // Repetition UI state
    @State private var repetitionEnabled: Bool = false
    @State private var customInterval: Int = 1
    @State private var repetitionUnit: RepetitionUnit = .day

    // End repetition toggle and date
    @State private var isEndRepetitionOn: Bool = false
    @State private var endrep: Date = Date()

    let numbers = Array(1...999)  // For selecting the interval

    var body: some View {
        VStack {
            // Drag indicator
            RoundedRectangle(cornerRadius: 4)
                .frame(width: 40, height: 5)
                .foregroundColor(Color.gray.opacity(0.5))
                .padding(.top, 8)

            // Navigation bar buttons
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Text("Cancel")
                        .padding([.leading, .bottom, .trailing])
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.red)
                }

                Spacer()

                Button(action: {
                    // Update task with selected values
                    task.startDateTime = starttime
                    task.endDateTime = endtime
                    task.repetition = repetitionEnabled ? Repetition(interval: customInterval, unit: repetitionUnit) : nil
                    task.endRepetition = isEndRepetitionOn ? endrep : nil

                    if !taskModel.checkTask(task) {
                        print("Task Added")
                        taskModel.addTask(task: task, context: contextt)
                        dismiss()
                    } else {
                        print("Task not added - potential overlap")
                    }
                }) {
                    Text("Add")
                        .padding([.leading, .bottom, .trailing])
                        .font(.system(size: 22, weight: .semibold))
                }
                .disabled(timeModel.timeGreater(startTime: starttime, endTime: endtime, startDate: starttime, endDate: endtime))
            }

            // Main form
            Form {
                // Section for basic details
                Section {
                    TextField("Name", text: $task.name)
                    TextField("Location", text: $task.location)
                    HStack{
                        Text("Tag")
                        Spacer()
                        Menu {
                            Button("Unselected") {
                                task.tag = nil
                            }
                            
                            ForEach(taskModel.tags) { tag in
                                Button {
                                    task.tag = tag
                                } label: {
                                    HStack {
                                        Text(tag.name)
                                        Spacer()
                                        Image(systemName: "tag.fill")
                                            .foregroundStyle(Color(hex: tag.color), .primary)
                                            .font(.caption)
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                if let selectedTag = task.tag {
                                    Text(selectedTag.name)
                                } else {
                                    Text("Unselected")
                                }
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.caption)
                            }
                            .foregroundStyle(.white)
                        }
                    }
                }

                // Section for date and repetition
                Section {
                    DatePicker("Start", selection: $starttime, displayedComponents: [.date, .hourAndMinute])
                    DatePicker("End", selection: $endtime, displayedComponents: [.date, .hourAndMinute])

                    // Toggle for enabling repetition
                    Toggle("Repeat Task", isOn: $repetitionEnabled)

                    // If repetition is enabled, show custom interval and unit pickers
                    if repetitionEnabled {
                        HStack {
                            Picker("Interval", selection: $customInterval) {
                                ForEach(numbers, id: \.self) { number in
                                    Text("\(number)").tag(number)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: 100, height: 150)

                            Spacer()

                            Picker("Unit", selection: $repetitionUnit) {
                                ForEach(RepetitionUnit.allCases, id: \.self) { unit in
                                    Text(unit.rawValue.capitalized).tag(unit)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: 150, height: 150)
                        }
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }

                    // Toggle and picker for ending repetition
                    Toggle("End Repetition", isOn: $isEndRepetitionOn)
                        .disabled(!repetitionEnabled)
                    if isEndRepetitionOn && repetitionEnabled {
                        DatePicker("", selection: $endrep, displayedComponents: .date)
                            .datePickerStyle(.wheel)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }

                // Section for notes
                Section(header: Text("Note")) {
                    TextEditor(text: $task.note)
                        .frame(minHeight: 100)
                        .foregroundColor(.primary)
                }
            }
            // Animate changes when repetitionEnabled or isEndRepetitionOn changes
            .animation(.easeInOut(duration: 0.5), value: repetitionEnabled)
            .animation(.easeInOut(duration: 0.2), value: isEndRepetitionOn)
            .onChange(of: repetitionEnabled) {
                if !repetitionEnabled {
                    isEndRepetitionOn = false
                }
            }
        }.preferredColorScheme(.dark)
    }
}

#Preview {
    BotttomSheetView()
        .environmentObject(DateModel())
        .environmentObject(TimeModel())
        .environmentObject(TaskModel())
}
