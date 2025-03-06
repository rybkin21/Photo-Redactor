//
//  DrawingScreen.swift
//  Photo Redactor
//
//  Created by Ivan Rybkin on 05.03.2025.
//

import SwiftUI
import PencilKit

struct DrawingScreen: View {
    @EnvironmentObject var model: DrawingViewModel
    
    var body: some View {

        ZStack {

            GeometryReader{ proxy -> AnyView in

                let size = proxy.frame(in: .global)

                DispatchQueue.main.async {
                    if model.rect == .zero {
                        model.rect = size
                    }
                }

                return AnyView(

                    ZStack {
                        // uikit pancilkit drawing view
                        CanvasView(canvas: $model.canvas, imageData: $model.imageData, toolPicker: $model.toolPicker, rect: size.size)
                            .padding(.horizontal, 20)

                        // custom texts

                        // displaying text box
                        ForEach(model.textBoxes) { box in

                            Text(model.textBoxes[model.currentIndex].id == box.id && model.addNewBox ? "" : box.text)
                                .font(.system(size: 30))
                                .fontWeight(box.isBold ? .bold : .none)
                                .foregroundStyle(box.textColor)
                                .offset(box.offset)

                            // drag gesture
                                .gesture(DragGesture().onChanged({ value in

                                    let current = value.translation
                                    //Adding with last Offset
                                    let lastOffset = box.lastOffset
                                    let newTranslation = CGSize(width: lastOffset.width + current.width, height: lastOffset.height + current.height)

                                    model.textBoxes[getIndex(textBox: box)].offset = newTranslation

                                }).onEnded({ value in

                                    // saving the last offset for exact drag position
                                    model.textBoxes[getIndex(textBox: box)].lastOffset = value.translation
                                }))
                            // editing text
                                .onLongPressGesture {
                                    // close toolbar
                                    model.toolPicker.setVisible(false, forFirstResponder: model.canvas)
                                    model.canvas.resignFirstResponder()
                                    model.currentIndex = getIndex(textBox: box)
                                    withAnimation {
                                        model.addNewBox = true
                                    }
                                }
                        }
                    }
                )
            }
        }
        .toolbar(content: {

            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action:
                    model.saveImage
               , label: {
                    Text("Save")
                })
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // creating one new box
                    model.textBoxes.append(TextBox())

                    // updating index
                    model.currentIndex = model.textBoxes.count - 1

                    withAnimation {
                        model.addNewBox.toggle()
                    }
                    // closing the tool bar
                    model.toolPicker.setVisible(false, forFirstResponder: model.canvas)
                    model.canvas.resignFirstResponder()}, label: {
                        Image(systemName: "plus")
                    })
            }
        })
    }

    func getIndex(textBox: TextBox) -> Int {

        let index = model.textBoxes.firstIndex { box -> Bool in
            return textBox.id == box.id
        } ?? 0

        return index
    }
}

#Preview {
    RedactorScreen()
}

struct CanvasView: UIViewRepresentable {

    @Binding var canvas: PKCanvasView
    @Binding var imageData: Data
    @Binding var toolPicker: PKToolPicker

    var rect: CGSize

    func makeUIView(context: Context) -> PKCanvasView {
        canvas.isOpaque = false
        canvas.backgroundColor = .clear
        canvas.drawingPolicy = .anyInput

        // Load the image if available
        if let image = UIImage(data: imageData) {
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.backgroundColor = .red


            let subView = canvas.subviews[0]
            subView.addSubview(imageView)
            subView.sendSubviewToBack(imageView)

            // Set up the tool picker
            toolPicker.setVisible(true, forFirstResponder: canvas)
            toolPicker.addObserver(canvas)
            canvas.becomeFirstResponder()
        }
        return canvas
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {

        }
    }
