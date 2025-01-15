//
//  FileViewModel.swift
//  OfflineNotes
//
//  Created by Naveen Raj on 12/01/25.
//

import Foundation
import SwiftUI
import CoreData

class FileViewModel: ObservableObject {
    @Published var files: [File] = []
    let folder: Folder
    private let context: NSManagedObjectContext

    init(folder: Folder) {
        guard let folderContext = folder.managedObjectContext else {
            fatalError("Folder must have a managed object context")
        }
        self.folder = folder
        self.context = folderContext // Use the folder's context
        fetchFiles()
    }

    func fetchFiles() {
        let request: NSFetchRequest<File> = File.fetchRequest()
        request.predicate = NSPredicate(format: "folder == %@", folder)
        request.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]

        do {
            files = try context.fetch(request)
            print("Fetched files: \(files)")
        } catch {
            print("Error fetching files: \(error)")
        }
    }

    func addFile(name: String, type: String, content: Data?) {
        let newFile = File(context: context)
        newFile.id = UUID()
        newFile.name = name
        newFile.type = type
        newFile.content = content
        newFile.folder = folder
        newFile.creationDate = Date()
        
        do {
            try context.save()
            fetchFiles()
        } catch {
            print("Error saving file: \(error)")
        }
    }

    func deleteFile(file: File) {
        context.delete(file)
        do {
            try context.save()
            fetchFiles()
        } catch {
            print("Error deleting file: \(error)")
        }
    }
}
