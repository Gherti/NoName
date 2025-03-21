import SwiftUI
import SwiftData

struct AdminView: View {
    @Environment(\.modelContext) private var context
    @Query private var tasks: [Task]  // Questa query recupera tutti i task dal database

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
        .onAppear {
            // Carica i dati quando la vista appare
            fetchTasks()
        }
    }

    // Funzione per stampare i Task
    func printTasks() {
        if tasks.isEmpty {
            print("Non ci sono task nel database.")
        } else {
            print("Ecco i task nel database:")
            for task in tasks {
                print("Task ID: \(task.id), Nome: \(task.name), Luogo: \(task.luogo), Inizio: \(task.start), Fine: \(task.end)")
            }
        }
    }

    // Funzione per eliminare tutti i Task
    func deleteAllTasks() {
        for task in tasks {
            context.delete(task)
        }
        try? context.save() // Salva il contesto dopo aver eliminato i task
        print("Tutti i task sono stati eliminati.")
    }
    
    // Funzione per ricaricare i task
    func fetchTasks() {
        // Non è necessario fare nulla perché @Query già recupera i task dal database
    }
}

#Preview {
    AdminView().modelContainer(for: Task.self)
}
