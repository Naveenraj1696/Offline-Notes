//
//  FileThumbnailView.swift
//  OfflineNotes
//
//  Created by Naveen Raj on 14/01/25.
//
import SwiftUI

struct FileThumbnailView: View {
    let fileData: Data
    let fileName: String
    let fileType: String
    @State private var thumbnail: UIImage?
    
    var body: some View {
        Group {
            if let thumbnail = thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
            } else {
                ProgressView()
                    .frame(width: 120, height: 120)
                    .onAppear {
                        generateThumbnail()
                    }
            }
        }
    }
    
    private func generateThumbnail() {
        if fileType == "pdf" {
            // Generate thumbnail for PDF
            if let pdfThumbnail = generatePDFThumbnail(data: fileData, size: CGSize(width: 120, height: 120)) {
                self.thumbnail = pdfThumbnail
            }
        } else {
            // Generate thumbnail for other files
            OfflineNotes.generateThumbnail(for: fileData, fileName: fileName, size: CGSize(width: 120, height: 120)) { image in
                DispatchQueue.main.async {
                    self.thumbnail = image
                }
            }
        }
    }
}
