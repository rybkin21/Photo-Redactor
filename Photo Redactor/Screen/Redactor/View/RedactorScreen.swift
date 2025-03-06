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

        ZStack {

            NavigationView {
                VStack {
                    if let _ = UIImage(data: model.imageData) {

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
            }

            if model.addNewBox {
                Color.black.opacity(0.75)
                    .ignoresSafeArea()

                // TextField
                TextField("Type here", text: $model.textBoxes[model.currentIndex].text)
                    .font(.system(size: 35, weight: model.textBoxes[model.currentIndex].isBold ? .bold : .regular))
                    .colorScheme(.dark)
                    .foregroundStyle(model.textBoxes[model.currentIndex].textColor)
                    .padding()

                //Add and cancel button
                HStack {

                    Button(action: {
                        //toggle isAdded
                        model.textBoxes[model.currentIndex].isAdded = true
                        // closing view
                        model.toolPicker.setVisible(true, forFirstResponder: model.canvas)
                        model.canvas.becomeFirstResponder()

                        withAnimation {
                            model.addNewBox = false
                            
                        } 
                    }, label: {
                        Text("Add")
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                            .padding()
                    })

                    Spacer()

                    Button(action: model.cancelTextView, label: {
                        Text("Cancel")
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                            .padding()
                    })
                }
                .overlay(

                    HStack(spacing: 15) {

                        // Color picker
                        ColorPicker("", selection: $model.textBoxes[model.currentIndex].textColor)
                            .labelsHidden()

                        Button(action: {
                            model.textBoxes[model.currentIndex].isBold.toggle()
                        }, label: {
                            Text(model.textBoxes[model.currentIndex].isBold ? "Normal" : "Bold")
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        })
                    }
                )
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        // Showing ImagePicker to pick Image
        .sheet(isPresented: $model.showImagePicker, content: {
            ImagePicker(showPicker: $model.showImagePicker, imageData: $model.imageData, sourceType: $model.sourceType)
        })
        .alert(isPresented: $model.showAlert, content: {
            Alert(title: Text("Message"), message: Text(model.message), dismissButton: .destructive(Text("Ok")))
        })
    }
}

#Preview {
    RedactorScreen()
}
