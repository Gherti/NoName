import SwiftUI
import SwiftData

struct AdminView: View {
    @Environment(\.modelContext) private var context
    @Query private var tasks: [Task]
    @Query private var tags: [Tag] // Query per ottenere tutti i Tag
    @EnvironmentObject var taskModel: TaskModel
    
    var body: some View {
        ZStack{
            Color("Background").ignoresSafeArea(.all)
            VStack {
                // Bottone per stampare i dati
                Button("Stampa tutti i Task") {
                    printTasks()
                }
                .padding()
                
                // Bottone per eliminare tutti i Task
                Button("Elimina tutti i Task") {
                    deleteAllTasks()
                }
                .padding()
                
                // Bottone per eliminare tutti i Tag
                Button("Elimina tutti i Tag") {
                    deleteAllTags()
                }
                .padding()
                
                // Bottone per eliminare Task e Tag
                Button("Elimina tutti i Task e i Tag") {
                    deleteAllTasksAndTags()
                }
                .padding()
            }
        }
    }

    // Funzione per stampare i Task
    func printTasks() {
        if tasks.isEmpty {
            print("Non ci sono task nel database.")
        } else {
            print("Ecco i task nel database:")
            for task in tasks {
                print("Task ID: \(task.id), Nome: \(task.name), Luogo: \(task.location), Inizio: \(task.startDateTime), Fine: \(task.endDateTime)")
            }
        }
    }

    // Funzione per eliminare tutti i Task
    func deleteAllTasks() {
        for task in tasks {
            context.delete(task)
        }
        do {
            try context.save()
            print("Tutti i task sono stati eliminati.")
            reloadTasksAndTags() // Ricarica i dati
        } catch {
            print("Errore durante l'eliminazione dei task: \(error.localizedDescription)")
        }
    }

    // Funzione per eliminare tutti i Tag
    func deleteAllTags() {
        for tag in tags {
            context.delete(tag)
        }
        do {
            try context.save()
            print("Tutti i tag sono stati eliminati.")
            reloadTasksAndTags() // Ricarica i dati
        } catch {
            print("Errore durante l'eliminazione dei tag: \(error.localizedDescription)")
        }
    }

    // Funzione per eliminare sia i Task che i Tag
    func deleteAllTasksAndTags() {
        for task in tasks {
            context.delete(task)
        }
        for tag in tags {
            context.delete(tag)
        }
        do {
            try context.save()
            print("Tutti i task e i tag sono stati eliminati.")
            reloadTasksAndTags() // Ricarica i dati
        } catch {
            print("Errore durante l'eliminazione di task e tag: \(error.localizedDescription)")
        }
    }
    
    // Funzione per ricaricare i task e i tag
    func reloadTasksAndTags() {
        taskModel.fetchTasks(context: context)
        taskModel.fetchTags(context: context)
    }
}

#Preview {
    AdminView()
        .modelContainer(for: Task.self)
        .modelContainer(for: Tag.self)
        .environmentObject(TaskModel())
}
