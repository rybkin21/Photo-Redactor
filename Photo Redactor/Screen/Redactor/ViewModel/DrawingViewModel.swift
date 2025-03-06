//
//  DrawingViewModel.swift
//  Photo Redactor
//
//  Created by Ivan Rybkin on 05.03.2025.
//

import SwiftUI
import PencilKit

class DrawingViewModel: ObservableObject {

    @Published var showImagePicker = false
    @Published var imageData: Data = Data(count: 0)
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary

    @Published var canvas = PKCanvasView()
    @Published var toolPicker = PKToolPicker()

    // List of text box
    @Published var textBoxes: [TextBox] = []

    @Published var addNewBox = false

    @Published var currentIndex: Int = 0

    // saving view frame size
    @Published var rect: CGRect = .zero

    // Alert
    @Published var showAlert = false
    @Published var message = ""

    //cancel func
    func cancelImageEditing() {
        imageData = Data(count: 0)
        canvas = PKCanvasView()
        textBoxes.removeAll()
    }

    //cancel the text view

    func cancelTextView() {

        toolPicker.setVisible(true, forFirstResponder: canvas)
        canvas.becomeFirstResponder()

        withAnimation {
            addNewBox = false
        }

        // removing if cancelled
        if !textBoxes[currentIndex].isAdded {
            textBoxes.removeLast()
        }

    }

    func saveImage() {
        guard rect.size != .zero else { return }

        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)

        let swiftUIView = ZStack {
            ForEach(textBoxes) { box in
                Text(box.text)
                    .font(.system(size: 30))
                    .fontWeight(box.isBold ? .bold : .regular)
                    .foregroundStyle(box.textColor)
                    .offset(box.offset)
            }
        }

        let controller = UIHostingController(rootView: swiftUIView)
        controller.view.frame = CGRect(origin: .zero, size: rect.size)
        controller.view.backgroundColor = .clear

        controller.view.layer.render(in: UIGraphicsGetCurrentContext()!)

        canvas.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)

        let generatedImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        if let image = generatedImage?.pngData() {
            // Save the image
            UIImageWriteToSavedPhotosAlbum(UIImage(data: image)!, nil, nil, nil)
            print("success")
            self.message = "Saved Successfully!"
            self.showAlert.toggle()
        }
    }
}
