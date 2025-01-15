//
//  AddFolderView.swift
//  OfflineNotes
//
//  Created by Naveen Raj on 12/01/25.
//

import SwiftUI

struct AddFolderView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @Binding var folder: Folder?
    @State private var folderName: String = ""
    @State private var folderColor: Color = Color.init(hex: "#9ACBF1")
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Folder Details")) {
                    HStack {
                        TextField("Enter folder name", text: $folderName)
                        ColorPicker("", selection: $folderColor)
                    }
                }
            }
            .navigationTitle(folder == nil ? "New Folder" : "Edit Folder")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(folder == nil ? "Save" : "Update") {
                        saveFolder()
                        dismiss()
                    }.disabled(folderName.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if let folder = folder {
                    folderName = folder.name ?? ""
                    folderColor = Color.init(hex: folder.color ?? "#9ACBF1")
                }
            }
        }
    }

    private func saveFolder() {
        if let folder = folder {
            // Update existing folder
            folder.name = folderName
            folder.color = folderColor.toHex
        } else {
            // Create a new folder
            let newFolder = Folder(context: viewContext)
            newFolder.id = UUID()
            newFolder.name = folderName
            newFolder.creationDate = Date()
            newFolder.color = folderColor.toHex
        }

        // Save context
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct AddFolderView_Previews: PreviewProvider {
    static var previews: some View {
        AddFolderView(folder: .constant(nil))
    }
}
