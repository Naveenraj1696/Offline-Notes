////
////  Persistence.swift
////  OfflineNotes
////
////  Created by Naveen Raj on 12/01/25.
////
//
import CoreData

class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "OfflineNotes")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error loading Core Data stores: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        container.viewContext
    }

    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
