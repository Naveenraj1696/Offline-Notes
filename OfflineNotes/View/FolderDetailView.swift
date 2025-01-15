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
            let columns = calculateColumns(for: screenWidth)

            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: columns), spacing: 16) {
                    ForEach(viewModel.files) { file in
                        VStack(spacing: 10) {
                            if let imageData = file.content, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: itemSize * 0.9, height: itemSize * 0.8)
                                    .cornerRadius(8)
                                    .clipped()
                            } else {
                                FileThumbnailView(
                                    fileData: file.content ?? Data(),
                                    fileName: file.name ?? "Untitled",
                                    fileType: file.type ?? "unknown"
                                )
                                .frame(width: itemSize * 0.9, height: itemSize * 0.8)
                            }

                            Text(file.name ?? "Untitled")
                                .font(.subheadline)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .frame(width: itemSize)
                                .truncationMode(.tail)
                            
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

    // Helper to calculate item size
    private func calculateItemSize(for width: CGFloat) -> CGFloat {
        let columnCount = calculateColumns(for: width)
        let spacing: CGFloat = 16 * CGFloat(columnCount - 1)
        return (width - spacing) / CGFloat(columnCount)
    }

    // Helper to calculate number of columns dynamically
    private func calculateColumns(for width: CGFloat) -> Int {
        return isPortrait ? (UIDevice.current.userInterfaceIdiom == .pad ? 5 : 3) : max( (UIDevice.current.userInterfaceIdiom == .pad ? 6 : 4), Int(width / 150)) // At least 4 in landscape, dynamically adjust for screen size
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
