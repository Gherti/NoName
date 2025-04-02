
import Foundation
import SwiftData
import SwiftUI

class TaskModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var tags: [Tag] = []
    
    func fetchTasks(context: ModelContext) {
            let descriptor = FetchDescriptor<Task>(sortBy: [SortDescriptor(\.startDateTime)])
            do {
                tasks = try context.fetch(descriptor)
                print("Fetched \(tasks.count) tasks")
            } catch {
                print("Error fetching tasks: \(error.localizedDescription)")
            }
        }
    
    func addTask(task: Task, context: ModelContext) {
        context.insert(task)
        print("Aggiunto task: \(task.name)")
        saveContext(context)  // Aggiungi il salvataggio esplicito
        fetchTasks(context: context) // Aggiorna la lista
    }

    func deleteTask(task: Task, context: ModelContext) {
        context.delete(task)
        saveContext(context)  // Aggiungi il salvataggio esplicito
        fetchTasks(context: context) // Aggiorna la lista
    }
    
    func checkTask(_ taskToCheck: Task) -> Bool {
        for task in tasks {
            // Verifica la sovrapposizione tra gli intervalli di tempo
            if taskToCheck.startDateTime < task.endDateTime && taskToCheck.endDateTime > task.startDateTime {
                return true
            }
        }
        return false
    }
    
    func saveContext(_ context: ModelContext) {
        do {
            try context.save()
            print("Salvato il contesto correttamente")
        } catch {
            print("Errore durante il salvataggio del contesto: \(error.localizedDescription)")
        }
    }
    
    //CatalogueTaskView
    func getTasks(selectedDate: (year: Int, month: Int, day: Int)?) -> [Task] {
        guard let selectedDate = selectedDate else { return [] }

        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = selectedDate.year
        dateComponents.month = selectedDate.month
        dateComponents.day = selectedDate.day

        guard let date = calendar.date(from: dateComponents) else { return [] }
        
        let selectedDay = calendar.startOfDay(for: date)
        let today = calendar.startOfDay(for: Date())
        
        // Only include tasks for today or future days
        if selectedDay < today { return [] }

        return tasks.filter { task in
            let startTaskDate = calendar.startOfDay(for: task.startDateTime)
            let endTaskDate = calendar.startOfDay(for: task.endDateTime)
            
            // Normal single-task check
            if startTaskDate <= selectedDay && selectedDay <= endTaskDate {
                return true
            }
            
            // Check for repeating tasks
            return isTaskRepeating(task: task, on: selectedDay)
        }
    }

    func isTaskRepeating(task: Task, on selectedDate: Date) -> Bool {
        guard let repetition = task.repetition else { return false }

        let calendar = Calendar.current
        let startTaskDate = calendar.startOfDay(for: task.startDateTime)
        let selectedDay = calendar.startOfDay(for: selectedDate)

        // Ensure the task's repetition period hasn't ended
        if let endRep = task.endRepetition, selectedDay > calendar.startOfDay(for: endRep) {
            return false
        }

        // Find the difference in days
        let dayDiff = calendar.dateComponents([.day], from: startTaskDate, to: selectedDay).day ?? 0

        switch repetition.unit {
        case .day:
            return dayDiff % repetition.interval == 0
        case .week:
            return dayDiff % (repetition.interval * 7) == 0
        case .month:
            let monthDiff = calendar.dateComponents([.month], from: startTaskDate, to: selectedDay).month ?? 0
            let startDay = calendar.component(.day, from: startTaskDate)
            let selectedDayNumber = calendar.component(.day, from: selectedDay)
            return (monthDiff % repetition.interval == 0) && (startDay == selectedDayNumber)
        case .year:
            let yearDiff = calendar.dateComponents([.year], from: startTaskDate, to: selectedDay).year ?? 0
            let startMonth = calendar.component(.month, from: startTaskDate)
            let startDay = calendar.component(.day, from: startTaskDate)
            let selectedMonth = calendar.component(.month, from: selectedDay)
            let selectedDayNumber = calendar.component(.day, from: selectedDay)
            return (yearDiff % repetition.interval == 0) && (startMonth == selectedMonth) && (startDay == selectedDayNumber)
        }
    }


    
    //TAG
    func addTag(tag: Tag, context: ModelContext) {
        context.insert(tag)
        print(tag.name)
        fetchTags(context: context) // Aggiorna la lista
    }
    
    func fetchTags(context: ModelContext) {
        let descriptor = FetchDescriptor<Tag>()
            do {
                tags = try context.fetch(descriptor)
                print("Fetched \(tags.count) tags")
            } catch {
                print("Error fetching tasks: \(error.localizedDescription)")
            }
        }
    
    func checkTag(tagToCheck: Tag) -> Bool {
        return tags.contains(where: { $0.name == tagToCheck.name}) || tags.contains(where: { $0.color == tagToCheck.color})
    }
}

