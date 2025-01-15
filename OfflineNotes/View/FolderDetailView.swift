//
//  FolderDetailView.swift
//  OfflineNotes
//
//  Created by Naveen Raj on 12/01/25.
//

import UIKit
import SwiftUI

struct FolderDetailView: View {
    @StateObject private var viewModel: FileViewModel
    @State private var showingFilePicker = false
    @State private var showingPhotoPicker = false
    @State private var isPortrait = true

    init(folder: Folder) {
        _viewModel = StateObject(wrappedValue: FileViewModel(folder: folder))
    }

    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let itemSize = calculateItemSize(for: screenWidth)

            ScrollView {
                LazyVGrid(columns: gridColumns(for: screenWidth), spacing: 16) {
                    ForEach(viewModel.files) { file in
                        VStack(spacing: 10) {
                            if let imageData = file.content, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: itemSize, height: itemSize)
                                    .cornerRadius(8)
                                    .clipped()
                            } else {
                                FileThumbnailView(
                                    fileData: file.content ?? Data(),
                                    fileName: file.name ?? "Untitled",
                                    fileType: file.type ?? "unknown"
                                )
                                .frame(width: itemSize, height: itemSize)
                            }

                            Text(file.name ?? "Untitled")
                                .font(.subheadline)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .frame(width: itemSize)
                            
                            Spacer()
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(viewModel.folder.name ?? "Folder")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Add File") { showingFilePicker = true }
                        Button("Add Photo") { showingPhotoPicker = true }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingPhotoPicker) {
                PhotoPicker { image in
                    if let image = image, let imageData = image.jpegData(compressionQuality: 0.8) {
                        viewModel.addFile(name: "".generateDynamicFileName(), type: "image", content: imageData)
                    }
                }
            }
            .sheet(isPresented: $showingFilePicker) {
                FilePicker { url in
                    let fileName = url.lastPathComponent
                    let fileType = url.pathExtension
                    if let fileData = try? Data(contentsOf: url) {
                        viewModel.addFile(name: fileName, type: fileType, content: fileData)
                    }
                }
            }
            .onAppear {
                updateOrientation(geometry: geometry)
            }
            .onChange(of: geometry.size) { _ in
                updateOrientation(geometry: geometry)
            }
        }
    }

    private func calculateItemSize(for width: CGFloat) -> CGFloat {
        let columnCount = isPortrait ? 3 : 5
        let spacing: CGFloat = 16 * CGFloat(columnCount - 1)
        return (width - spacing) / CGFloat(columnCount)
    }

    private func gridColumns(for width: CGFloat) -> [GridItem] {
        let columnCount = isPortrait ? 3 : 5
        return Array(repeating: GridItem(.flexible(), spacing: 16), count: columnCount)
    }

    private func updateOrientation(geometry: GeometryProxy) {
        isPortrait = geometry.size.width < geometry.size.height
    }
}

struct FolderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FolderDetailView(folder: Folder())
    }
}
