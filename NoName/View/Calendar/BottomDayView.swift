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
                    dateModel.previousDay()
                    
                }) {
                    Text("Previous")
                        .padding([.leading, .bottom, .trailing])
                        .font(.system(size: 22, weight: .semibold))
                }
                
                Spacer()
                
                Button(action: {
                    
                        dateModel.nextDay()
                    
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
