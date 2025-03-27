import SwiftUI

struct BottomDayView: View {
    @EnvironmentObject var dateModel: DateModel
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 4)
                .frame(width: 40, height: 5)
                .foregroundColor(Color.gray.opacity(0.5))
                .padding(.top, 8)
            
            HStack {
                Button(action: {
                    withAnimation(.spring()) {
                        dateModel.previousDay()
                    }
                }) {
                    Text("Previous")
                        .padding([.leading, .bottom, .trailing])
                        .font(.system(size: 22, weight: .semibold))
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring()) {
                        dateModel.nextDay()
                    }
                }) {
                    Text("Next")
                        .padding([.leading, .bottom, .trailing])
                        .font(.system(size: 22, weight: .semibold))
                }
            }
            
            if let selectedDate = dateModel.selectedDate {
                let nameOfDay = dateModel.getWeekdayName(year: selectedDate.year, month: selectedDate.month, day: selectedDate.day) ?? "Unknown"
                
                Text("\(nameOfDay), \(selectedDate.day) \(dateModel.months[selectedDate.month-1]) \(String(selectedDate.year))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .fontWeight(.bold)
                    .padding()
                    .offset(x: dragOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragOffset = value.translation.width
                            }
                            .onEnded { value in
                                if value.translation.width < -100 {
                                    withAnimation(.spring()) {
                                        dateModel.nextDay()
                                    }
                                } else if value.translation.width > 100 {
                                    withAnimation(.spring()) {
                                        dateModel.previousDay()
                                    }
                                }
                                dragOffset = 0
                            }
                    )
                    .animation(.spring(), value: dragOffset)
            } else {
                Text("No Task for Today")
                    .font(.subheadline)
                    .padding()
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            CatalogueTaskView()
                .overlay(
                    Group {
                        if dateModel.viewTaskInfo {
                            Color.black.opacity(0.5)
                                .ignoresSafeArea()
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        dateModel.viewTaskInfo = false
                                    }
                                }
                            
                            TaskInfoView()
                                .frame(width: 300, height: 450)
                                .offset(y: -50)
                                .transition(.move(edge: .bottom))
                        }
                    }
                )
        }
        .background(Color.black)
    }
}

#Preview {
    BottomDayView()
        .environmentObject(DateModel())
        .environmentObject(TimeModel())
        .environmentObject(TaskModel()) 
}
