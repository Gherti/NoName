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
                    .padding()
                    .offset(x: dragOffset) // Applica lo spostamento per l'animazione
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragOffset = value.translation.width // Segue il dito
                            }
                            .onEnded { value in
                                if value.translation.width < -100 { // Swipe verso sinistra (giorno successivo)
                                    withAnimation(.spring()) {
                                        dateModel.nextDay()
                                    }
                                } else if value.translation.width > 100 { // Swipe verso destra (giorno precedente)
                                    withAnimation(.spring()) {
                                        dateModel.previousDay()
                                    }
                                }
                                dragOffset = 0 // Ritorna alla posizione iniziale
                            }
                    )
                    .animation(.spring(), value: dragOffset) // Applica animazione al cambio
            } else {
                Text("Nessuna data selezionata")
                    .font(.subheadline)
                    .padding()
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            CatalogueTaskView()
            
            ///Show Task
        }
    }
}

#Preview {
    BottomDayView()
        .environmentObject(DateModel())
        .environmentObject(TimeModel())
        .environmentObject(ToDoModel()) 
}
