//
//  FolderViewModel.swift
//  OfflineNotes
//
//  Created by Naveen Raj on 12/01/25.
//

import Foundation
import SwiftUI
import CoreData

class FolderViewModel: ObservableObject {
    @Published var folders: [Folder] = []
    @Published var sortByDate: Bool = true

    private let context = CoreDataManager.shared.context

    init() {
        fetchFolders()
    }

    func fetchFolders() {
        let request: NSFetchRequest<Folder> = Folder.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: sortByDate ? "creationDate" : "name", ascending: true)]
        folders = (try? context.fetch(request)) ?? []
    }

    func addFolder(name: String, color: String, isFavorite: Bool) {
        let newFolder = Folder(context: context)
        newFolder.id = UUID()
        newFolder.name = name
        newFolder.creationDate = Date()
        newFolder.color = color
        newFolder.isFavorite = isFavorite

        saveChanges()
    }

    func deleteFolder(folder: Folder) {
        context.delete(folder)
        saveChanges()
    }

    func toggleFavorite(folder: Folder) {
        folder.isFavorite.toggle()
        saveChanges()
    }

    private func saveChanges() {
        CoreDataManager.shared.saveContext()
        fetchFolders()
    }
}
