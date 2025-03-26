import SwiftUI
import SwiftData

struct AdminView: View {
    @Environment(\.modelContext) private var context
    @Query private var tasks: [Task]
    @EnvironmentObject var taskModel: TaskModel
    
    var body: some View {
        VStack {
            // Bottone per stampare i dati
            Button("Stampa tutti i Task") {
                printTasks()
            }
            .padding()

            // Bottone per eliminare tutti i dati
            Button("Elimina tutti i Task") {
                deleteAllTasks()
            }
            .padding()
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
        do {
            // Use batch delete for efficiency
            try context.delete(model: Task.self)
            
            // Alternatively, if you want to delete individually:
            // tasks.forEach { context.delete($0) }
            
            try context.save()
            print("Tutti i task sono stati eliminati.")
        } catch {
            print("Errore durante l'eliminazione dei task: \(error.localizedDescription)")
        }
    }
}

#Preview {
    AdminView()
        .modelContainer(for: Task.self)
        .environmentObject(TaskModel())
}
