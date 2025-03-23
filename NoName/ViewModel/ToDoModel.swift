import Foundation
import SwiftData
import SwiftUI

class ToDoModel: ObservableObject {
    
    @Published private var tasks: [Task] = []
    
    func fetchTasks(context: ModelContext) {
            let descriptor = FetchDescriptor<Task>()
            do {
                tasks = try context.fetch(descriptor)
            } catch {
                print("Failed to fetch tasks: \(error)")
            }
        }
    
    func getTasks(selectedDate: (year: Int, month: Int, day: Int)?) -> [Task] {
        guard let selectedDate = selectedDate else { return [] }

        let calendar = Calendar.current
        
        // Creiamo la data con year, month, day
        var dateComponents = DateComponents()
        dateComponents.year = selectedDate.year
        dateComponents.month = selectedDate.month
        dateComponents.day = selectedDate.day
        
        guard let date = calendar.date(from: dateComponents) else {
            return [] // Se la data non è valida, restituiamo una lista vuota
        }
        
        // Filtriamo i task con la stessa data
        return tasks.filter { task in
            let taskDate = calendar.startOfDay(for: task.startDate)
            let selectedDay = calendar.startOfDay(for: date)
            return taskDate == selectedDay
        }
    }
    /// Combina la data e l'orario ignorando i secondi (impostandoli a 0)
    private func combine(date: Date, time: Date) -> Date? {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        
        var combinedComponents = DateComponents()
        combinedComponents.year = dateComponents.year
        combinedComponents.month = dateComponents.month
        combinedComponents.day = dateComponents.day
        combinedComponents.hour = timeComponents.hour
        combinedComponents.minute = timeComponents.minute
        combinedComponents.second = 0
        
        return calendar.date(from: combinedComponents)
    }
    
    /// Controlla se il task da verificare si sovrappone ad un task già esistente.
    /// Ritorna true se c'è sovrapposizione, false altrimenti.
    func checkTask(_ taskToCheck: Task) -> Bool {
        guard let newStart = combine(date: taskToCheck.startDate, time: taskToCheck.startTime),
              let newEnd = combine(date: taskToCheck.endDate, time: taskToCheck.endTime) else {
            return false
        }
        
        for task in tasks {
            guard let existingStart = combine(date: task.startDate, time: task.startTime),
                  let existingEnd = combine(date: task.endDate, time: task.endTime) else {
                continue
            }
            
            // Verifica la sovrapposizione degli intervalli:
            // Il nuovo task si sovrappone se inizia prima che termini un task esistente
            // e finisce dopo che è iniziato quel task.
            if newStart < existingEnd && newEnd > existingStart {
                return true
            }
        }
        return false
    }
    
    func addTaskIfPossible(_ task: Task, context: ModelContext) -> Bool {
            // First refresh our task list
            fetchTasks(context: context)
            
            // Check if task overlaps
            if !checkTask(task) {
                context.insert(task)
                print(task)
                print("Task aggiunto")
                return true
            } else {
                print("Task non aggiunto - sovrapposizione")
                return false
            }
        }
}
