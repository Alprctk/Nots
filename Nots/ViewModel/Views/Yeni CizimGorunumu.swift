//
//  Yeni CizimGorunumu.swift
//  Nots
//
//  Created by Alper Çatak on 17.07.2024.
//

import SwiftUI
import PencilKit

struct CizimGorunumu: View {
    @Binding var cizim: String
    @Environment(\.presentationMode) var presentationMode
    @State private var canvasView = PKCanvasView()
    @State private var toolPicker = PKToolPicker()

    var body: some View {
        NavigationView {
            VStack {
                canvasViewContainer
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding()
                    .onAppear {
                        setupCanvas()
                    }
                
                Spacer()
                
                HStack {
                    Button(action: {
                        canvasView.tool = PKInkingTool(.pen, color: .black, width: 5)
                    }) {
                        Image(systemName: "pencil")
                    }
                    .padding()
                    
                    Button(action: {
                        canvasView.tool = PKInkingTool(.marker, color: .black, width: 10)
                    }) {
                        Image(systemName: "highlighter")
                    }
                    .padding()
                    
                    Button(action: {
                        canvasView.tool = PKEraserTool(.vector)
                    }) {
                        Image(systemName: "eraser")
                    }
                    .padding()
                }
            }
            .navigationBarTitle("Çizim", displayMode: .inline)
            .navigationBarItems(leading: Button("Vazgeç") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Kaydet") {
                saveDrawing()
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    private var canvasViewContainer: some View {
        CanvasView(canvasView: $canvasView, toolPicker: $toolPicker)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func setupCanvas() {
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 5)
    }

    private func saveDrawing() {
        let image = canvasView.drawing.image(from: canvasView.drawing.bounds, scale: 1.0)
        if let imageData = image.pngData(), let base64String = imageData.base64EncodedString() as String? {
            cizim = base64String
        }
    }
}

struct CanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    @Binding var toolPicker: PKToolPicker

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {}
}

struct CizimGorunumu_Previews: PreviewProvider {
    static var previews: some View {
        CizimGorunumu(cizim: .constant(""))
    }
}
