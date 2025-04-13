import Foundation
import SwiftData
import SwiftUI

class TaskModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var tags: [Tag] = []
    
    // MARK: - Task Management
    
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
        print("Added task: \(task.name)")
        saveContext(context)
        fetchTasks(context: context)
    }

    func deleteTask(task: Task, context: ModelContext) {
        context.delete(task)
        saveContext(context)
        fetchTasks(context: context)
    }
    
    func updateTask(task: Task, context: ModelContext) {
        // No need to explicitly update as SwiftData tracks the object
        saveContext(context)
        fetchTasks(context: context)
    }
    
    func checkTask(_ taskToCheck: Task) -> Bool {
        for task in tasks {
            if task.id == taskToCheck.id {
                continue // Skip self-comparison
            }
            
            // Check for time overlap
            if taskToCheck.startDateTime < task.endDateTime && taskToCheck.endDateTime > task.startDateTime {
                return true // Overlap detected
            }
        }
        return false
    }
    
    func saveContext(_ context: ModelContext) {
        do {
            try context.save()
            print("Context saved successfully")
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Task Filtering for Selected Date
    
    func getTasks(selectedDate: (year: Int, month: Int, day: Int)?) -> [Task] {
        guard let selectedDate = selectedDate else { return [] }

        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = selectedDate.year
        dateComponents.month = selectedDate.month
        dateComponents.day = selectedDate.day

        guard let date = calendar.date(from: dateComponents) else { return [] }
        
        let selectedDay = calendar.startOfDay(for: date)
        
        // Only include tasks for today or future days
        

        return tasks.filter { task in
            isTaskOccurringOnDate(task: task, date: selectedDay)
        }
    }
    
    // MARK: - Task Occurrence Logic
    
    func isTaskOccurringOnDate(task: Task, date: Date) -> Bool {
        let calendar = Calendar.current
        let startTaskDate = calendar.startOfDay(for: task.startDateTime)
        let endTaskDate = calendar.startOfDay(for: task.endDateTime)
        let selectedDay = calendar.startOfDay(for: date)
        
        guard let rep = task.repetition else {
            return selectedDay >= startTaskDate && selectedDay <= endTaskDate // Not a repeating task and not within date range
        }
        
        if let endRepDate = task.endRepetition, selectedDay > calendar.startOfDay(for: endRepDate) {
            return false
        }
        
        
        switch rep.unit {
            case .day:
                let diffDay = calendar.dateComponents([.day], from: startTaskDate, to: selectedDay).day ?? 0
                if startTaskDate == endTaskDate{
                    return diffDay % rep.interval == 0
                }
                let taskDurationDay = calendar.dateComponents([.day], from: startTaskDate, to: endTaskDate).day ?? 0
                for i in 0...taskDurationDay {
                    let dayToCheck = calendar.date(byAdding: .day, value: i, to: startTaskDate)!
                    let diffDay = calendar.dateComponents([.day], from: dayToCheck, to: selectedDay).day ?? 0
                    if diffDay % rep.interval == 0{
                        return true
                    }
                }
                return false
                
            case .week:
                let diffDay = calendar.dateComponents([.day], from: startTaskDate, to: selectedDay).day ?? 0
                if startTaskDate == endTaskDate{
                    return diffDay % (rep.interval * 7) == 0
                }
                let taskDurationDay = calendar.dateComponents([.day], from: startTaskDate, to: endTaskDate).day ?? 0
                for i in 0...taskDurationDay {
                    let dayToCheck = calendar.date(byAdding: .day, value: i, to: startTaskDate)!
                    let diffDay = calendar.dateComponents([.day], from: dayToCheck, to: selectedDay).day ?? 0
                    if diffDay % (rep.interval*7) == 0{
                        return true
                    }
                }
                return false
                
            case .month:
                let diffMonth = calendar.dateComponents([.month], from: startTaskDate, to: selectedDay).month ?? 0
                let startDay = calendar.component(.day, from: startTaskDate)
                let selectDay = calendar.component(.day, from: selectedDay)
                //single day
                if startTaskDate == endTaskDate{
                    if diffMonth % rep.interval == 0{
                        if startDay == 31 {
                            //prendo l'ultimo giorno del mese di selected day
                            let range = calendar.range(of: .day, in: .month, for: selectedDay)
                            let lastDayMonth = range?.count
                            return selectDay == lastDayMonth
                        }
                        else {
                            return startDay == selectDay
                        }
                    }
                    
                }
                //multiDays
            
                var projectedStartDate = startTaskDate
                var projectedEndDate = endTaskDate

                while projectedStartDate <= selectedDay {
                    if selectedDay >= projectedStartDate && selectedDay <= projectedEndDate {
                        return true
                    }
                    // Proietta al prossimo intervallo
                    projectedStartDate = calendar.date(byAdding: .month, value: rep.interval, to: projectedStartDate)!
                    projectedEndDate = calendar.date(byAdding: .month, value: rep.interval, to: projectedEndDate)!
                }
                return false
            
            case .year:
                let diffMonth = calendar.dateComponents([.month], from: startTaskDate, to: selectedDay).month ?? 0
                let startDay = calendar.component(.day, from: startTaskDate)
                let selectDay = calendar.component(.day, from: selectedDay)
                //single day
                if startTaskDate == endTaskDate{
                    if diffMonth % rep.interval*12 == 0{
                        if startDay == 31 {
                            //prendo l'ultimo giorno del mese di selected day
                            let range = calendar.range(of: .day, in: .month, for: selectedDay)
                            let lastDayMonth = range?.count
                            return selectDay == lastDayMonth
                        }
                        else {
                            return startDay == selectDay
                        }
                    }
                    
                }
                //multiDays
                var projectedStartDate = startTaskDate
                var projectedEndDate = endTaskDate

                while projectedStartDate <= selectedDay {
                    if selectedDay >= projectedStartDate && selectedDay <= projectedEndDate {
                        return true
                    }
                    // Proietta al prossimo intervallo
                    projectedStartDate = calendar.date(byAdding: .month, value: rep.interval*12, to: projectedStartDate)!
                    projectedEndDate = calendar.date(byAdding: .month, value: rep.interval*12, to: projectedEndDate)!
                }
                return false
        }
    }
    
    // MARK: - Tag Management
    
    func addTag(tag: Tag, context: ModelContext) {
        context.insert(tag)
        saveContext(context)
        fetchTags(context: context)
    }
    
    func fetchTags(context: ModelContext) {
        let descriptor = FetchDescriptor<Tag>()
        do {
            tags = try context.fetch(descriptor)
            print("Fetched \(tags.count) tags")
        } catch {
            print("Error fetching tags: \(error.localizedDescription)")
        }
    }
    
    func checkTag(tagToCheck: Tag) -> Bool {
        return tags.contains(where: { $0.name == tagToCheck.name }) ||
               tags.contains(where: { $0.color == tagToCheck.color })
    }
}
