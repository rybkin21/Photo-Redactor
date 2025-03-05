//
//  RedactorScreen.swift
//  Photo Redactor
//
//  Created by Ivan Rybkin on 05.03.2025.
//

import SwiftUI

struct RedactorScreen: View {
    @StateObject var model = DrawingViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if let imageFile = UIImage(data: model.imageData) {

                    DrawingScreen()
                        .environmentObject(model)

                    //setting cancel button if image selected
                        .toolbar(content: {

                            ToolbarItem(placement: .navigationBarLeading) {
                                Button(action: model.cancelImageEditing
                                       , label: {
                                    Image(systemName: "xmark")
                                })
                            }
                        })
                } else {
                    // Show image picker buttons
                    VStack(spacing: 50) {

                        Button(action: {
                            model.sourceType = .photoLibrary
                            model.showImagePicker.toggle()
                        }, label: {

                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .font(.title)
                                .foregroundStyle(.gray.opacity(0.5))
                                .frame(width: 100, height: 100)
                                .shadow(color: Color.gray.opacity(0.3), radius: 5, x: -5, y: -5)
                        })

                        Button(action: {
                            model.sourceType = .camera
                            model.showImagePicker.toggle()
                        }, label: {
                            Image(systemName: "camera")
                                .resizable()
                                .scaledToFit()
                                .font(.title)
                                .foregroundStyle(.gray.opacity(0.5))
                                .frame(width: 100, height: 100)
                                .shadow(color: Color.gray.opacity(0.3), radius: 5, x: -5, y: -5)
                        })
                    }
                    .padding()
                }
            }
            .navigationTitle("Image Editor")
            .sheet(isPresented: $model.showImagePicker) {
                ImagePicker(showPicker: $model.showImagePicker, imageData: $model.imageData, sourceType: $model.sourceType)
            }
        }
    }
}

#Preview {
    RedactorScreen()
}
