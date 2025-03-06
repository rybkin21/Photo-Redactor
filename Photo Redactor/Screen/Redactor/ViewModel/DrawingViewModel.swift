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

    //cancel func
    func cancelImageEditing() {
        imageData = Data(count: 0)
        canvas = PKCanvasView()
    }
}


