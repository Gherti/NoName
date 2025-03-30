//
//  CodeStorage.swift
//  NoName
//
//  Created by Leonardo Ghimenti on 29/03/25.
//

/*
 .confirmationDialog("Scegli un'opzione", isPresented: $isDentsPresented, titleVisibility: .visible) {
 Button("Opzione 1") { print("Scelta 1") }
 Button("Opzione 2") { print("Scelta 2") }
 Button("Annulla", role: .cancel) {}
 
 ELIMINARE I TAG
 func deleteLabel(_ label: Label) {
     // Rimuovi il tag dai task associati
     for task in tasks where task.labels.contains(label) {
         task.labels.removeAll { $0.id == label.id }
     }
     
     // Ora puoi rimuovere il tag dal database
     // Esegui la cancellazione del tag dal database
 }
}

 onSetup: { container in
         // Controlla se è la prima esecuzione dell'app
         let context = ModelContext(container)
         let fetchDescriptor = FetchDescriptor<Tag>()
         
         do {
             let existingTags = try context.fetch(fetchDescriptor)
             
             // Se non ci sono tag, crea alcuni tag predefiniti
             if existingTags.isEmpty {
                 print("Precaricamento dei tag predefiniti...")
                 let workTag = Tag(name: "Lavoro", color: "#FF0000", emoji: "💼")
                 let personalTag = Tag(name: "Personale", color: "#00FF00", emoji: "🏠")
                 let urgentTag = Tag(name: "Urgente", color: "#FF00FF", emoji: "⚠️")
                 
                 context.insert(workTag)
                 context.insert(personalTag)
                 context.insert(urgentTag)
                 
                 try context.save()
                 print("Tag predefiniti creati con successo")
             }
         } catch {
             print("Errore durante il setup del database: \(error)")
         }
     }
 
 configurations: Permette di specificare configurazioni personalizzate per ciascun tipo di modello, utile quando hai requisiti diversi per entità diverse.
 schema: Consente di definire esplicitamente lo schema del database, utile per versioni e migrazioni.
 groupContainer: Specifica un ID gruppo container per condividere i dati tra app diverse dello stesso sviluppatore (utile per app con estensioni).
 url: Permette di specificare esplicitamente dove salvare il database invece di usare la posizione predefinita.
 cloudKitContainerIdentifier: Per abilitare la sincronizzazione con CloudKit, permettendo ai dati di sincronizzarsi tra i dispositivi dell'utente.
 onSetup: Un closure che viene eseguito quando il container viene configurato per la prima volta, utile per la migrazione dei dati o per la configurazione iniziale.
 
*/
