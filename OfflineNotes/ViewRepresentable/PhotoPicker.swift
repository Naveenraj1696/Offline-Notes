//
//  PhotoPicker.swift
//  OfflineNotes
//
//  Created by Naveen Raj on 12/01/25.
//

import Foundation
import UIKit
import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable {
    let onPick: (UIImage?) -> Void

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onPick: onPick)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let onPick: (UIImage?) -> Void

        init(onPick: @escaping (UIImage?) -> Void) {
            self.onPick = onPick
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            let image = info[.originalImage] as? UIImage
            onPick(image)
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            onPick(nil)
            picker.dismiss(animated: true)
        }
        
    }
}
