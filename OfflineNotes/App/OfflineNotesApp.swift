//
//  OfflineNotesApp.swift
//  OfflineNotes
//
//  Created by Naveen Raj on 12/01/25.
//

import SwiftUI

@main
struct OfflineNotesApp: App {
    // Create a shared instance of PersistenceController
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            FolderListView()
                // Pass the managedObjectContext to the environment
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

