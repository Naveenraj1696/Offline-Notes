//
//  GenerateFile.swift
//  OfflineNotes
//
//  Created by Naveen Raj on 14/01/25.
//
import UIKit
import QuickLookThumbnailing
import PDFKit

func generatePDFThumbnail(data: Data, size: CGSize) -> UIImage? {
    guard let pdfDocument = PDFDocument(data: data),
          let page = pdfDocument.page(at: 0) else {
        return nil
    }
    
    let pdfPageRect = page.bounds(for: .mediaBox)
    let scale = min(size.width / pdfPageRect.width, size.height / pdfPageRect.height)
    let scaledSize = CGSize(width: pdfPageRect.width * scale, height: pdfPageRect.height * scale)
    
    UIGraphicsBeginImageContextWithOptions(scaledSize, false, 0)
    guard let context = UIGraphicsGetCurrentContext() else {
        return nil
    }
    
    context.saveGState()
    context.translateBy(x: 0, y: scaledSize.height)
    context.scaleBy(x: 1.0, y: -1.0)
    
    context.scaleBy(x: scale, y: scale)
    page.draw(with: .mediaBox, to: context)
    context.restoreGState()
    
    let thumbnail = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return thumbnail
}

func generateThumbnail(for data: Data, fileName: String, size: CGSize, completion: @escaping (UIImage?) -> Void) {
    // Save the data to a temporary file
    let tempDirectory = FileManager.default.temporaryDirectory
    let fileURL = tempDirectory.appendingPathComponent(fileName)
    
    do {
        try data.write(to: fileURL)
    } catch {
        print("Failed to write file to temporary directory: \(error)")
        completion(nil)
        return
    }
    
    // Generate the thumbnail
    let request = QLThumbnailGenerator.Request(
        fileAt: fileURL,
        size: size,
        scale: UIScreen.main.scale,
        representationTypes: .all
    )
    
    let generator = QLThumbnailGenerator.shared
    generator.generateBestRepresentation(for: request) { (thumbnail, error) in
        if let thumbnail = thumbnail {
            completion(thumbnail.uiImage)
        } else {
            print("Thumbnail generation failed: \(error?.localizedDescription ?? "Unknown error")")
            completion(nil)
        }
    }
}
