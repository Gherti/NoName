
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
        print(task.name)
        fetchTasks(context: context) // Aggiorna la lista
    }
    
    func deleteTask(task: Task, context: ModelContext) {
        context.delete(task)
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
    
    //CatalogueTaskView
    func getTasks(selectedDate: (year: Int, month: Int, day: Int)?) -> [Task] {
        guard let selectedDate = selectedDate else { return [] }
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = selectedDate.year
        dateComponents.month = selectedDate.month
        dateComponents.day = selectedDate.day
        
        guard let date = calendar.date(from: dateComponents) else {
            return []
        }
        
        // Filtriamo i task con la stessa data
        return tasks.filter { task in
            let startTaskDate = calendar.startOfDay(for: task.startDateTime)
            let endTaskDate = calendar.startOfDay(for: task.endDateTime)
            let selectedDay = calendar.startOfDay(for: date)
            
            if startTaskDate > selectedDay || selectedDay > endTaskDate{
                return false
            }
            else{
                return true
            }
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

