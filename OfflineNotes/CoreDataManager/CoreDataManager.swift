//
//  CoreDataManager.swift
//  OfflineNotes
//
//  Created by Naveen Raj on 12/01/25.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "OfflineFiles")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data load failed: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            try? context.save()
        }
    }
}
