//
//  FolderListView.swift
//  OfflineNotes
//
//  Created by Naveen Raj on 12/01/25.
//
import SwiftUI
import UIKit

enum FolderSortOption: String {
    case name = "Name"
    case creationDate = "Creation Date"
}

struct FolderListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var currentSortOption: FolderSortOption = .name
    @State private var showingAddFolder = false
    @State private var showingColorPicker = false
    @State private var selectedFolder: Folder?
    @State private var isPortrait = true

    // Declare a @FetchRequest property and bind dynamic sort descriptors to it
    @FetchRequest var folders: FetchedResults<Folder>

    // Initialize FetchRequest with default sort descriptors
    init() {
        let sortDescriptor: SortDescriptor<Folder> = SortDescriptor(\Folder.name, order: .forward)
        _folders = FetchRequest(sortDescriptors: [sortDescriptor], animation: .default)
    }

    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let itemSize = calculateItemSize(for: screenWidth)
            let columns = calculateColumns(for: screenWidth)
            
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: columns), spacing: 16) {
                        ForEach(folders) { folder in
                            VStack {
                                NavigationLink(destination: FolderDetailView(folder: folder)) {
                                    VStack(spacing: 0) {
                                        Image("folder")
                                            .renderingMode(.template)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: itemSize, height: itemSize)
                                            .foregroundColor(Color(hex: folder.color ?? "#FFFFFF"))
                                        
                                        Text(folder.name ?? "")
                                            .foregroundColor(.black)
                                            .font(.headline)
                                            .lineLimit(1)
                                            .multilineTextAlignment(.center)
                                        
                                        let formattedDate = "\(folder.creationDate ?? Date())".formattedDate(
                                            from: "yyyy-MM-dd HH:mm:ss Z",
                                            to: "yyyy-MMM-dd, hh:mm a"
                                        )
                                        if let formattedDate = formattedDate {
                                            Text(formattedDate)
                                                .font(.footnote)
                                                .foregroundColor(.secondary)
                                                .lineLimit(2)
                                        }
                                    }
                                }
                            }
                            .contextMenu {
                                Button {
                                    toggleFavorite(for: folder)
                                } label: {
                                    Label("Favourite", systemImage: folder.isFavorite ? "star.fill" : "star")
                                }
                                
                                Button {
                                    selectedFolder = folder
                                    showingAddFolder.toggle()
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                            }
                        }
                    }
                    .padding()
                }
                .navigationTitle("Folders")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Section {
                                Button(action: {
                                    showingAddFolder.toggle()
                                }) {
                                    HStack {
                                        Text("New Folder")
                                        Image(systemName: "folder.badge.plus")
                                    }
                                }
                            }
                            
                            Section {
                                
                                Button(action: {
                                  
                                }) {
                                    HStack {
                                        Text("Sort by")
                                        Image(systemName: "chevron.up.chevron.down")
                                    }
                                }
                                .disabled(true)
                                
                                Button(action: {
                                    currentSortOption = .name
                                    updateSortDescriptor()
                                }) {
                                    HStack {
                                        Text("Name")
                                        if currentSortOption == .name {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                                
                                Button(action: {
                                    currentSortOption = .creationDate
                                    updateSortDescriptor()
                                }) {
                                    HStack {
                                        Text("Creation Date")
                                        if currentSortOption == .creationDate {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
                .sheet(isPresented: $showingAddFolder) {
                    AddFolderView(folder: $selectedFolder)
                        .environment(\.managedObjectContext, viewContext)
                        .presentationDetents([.medium])
                }
                .onAppear {
                    updateOrientation(geometry: geometry)
                }
                .onChange(of: geometry.size) { _ in
                    updateOrientation(geometry: geometry)
                }
            }
            .navigationViewStyle(.stack)
        }
    }

    // Helper to calculate item size
    private func calculateItemSize(for width: CGFloat) -> CGFloat {
        let columnCount = calculateColumns(for: width)
        let spacing: CGFloat = 16 * CGFloat(columnCount - 1)
        return (width - spacing) / CGFloat(columnCount)
    }

    // Helper to calculate number of columns dynamically
    private func calculateColumns(for width: CGFloat) -> Int {
        return isPortrait ? 3 : max(4, Int(width / 150)) // At least 4 in landscape, dynamically adjust for screen size
    }

    // Detect orientation
    private func updateOrientation(geometry: GeometryProxy) {
        isPortrait = geometry.size.width < geometry.size.height
    }

    private func toggleFavorite(for folder: Folder) {
        folder.isFavorite.toggle()
        saveContext()
    }

    private func updateSortDescriptor() {
        let sortDescriptor: SortDescriptor<Folder>
        if currentSortOption == .name {
            sortDescriptor = SortDescriptor(\Folder.name, order: .forward)
        } else {
            sortDescriptor = SortDescriptor(\Folder.creationDate, order: .forward)
        }
        
        folders.sortDescriptors = [sortDescriptor]
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct FolderListView_Previews: PreviewProvider {
    static var previews: some View {
        FolderListView()
    }
}

