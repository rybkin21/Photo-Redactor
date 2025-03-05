//
//  ImagePicker.swift
//  Photo Redactor
//
//  Created by Ivan Rybkin on 05.03.2025.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var showPicker: Bool
    @Binding var imageData: Data
    @Binding var sourceType: UIImagePickerController.SourceType

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = sourceType
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        uiViewController.sourceType = sourceType
    }
}

class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var parent: ImagePicker

    init(parent: ImagePicker) {
        self.parent = parent
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageData = (info[.originalImage] as? UIImage)?.pngData() {
            parent.imageData = imageData
        }
        parent.showPicker.toggle()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        parent.showPicker.toggle()
    }
}
