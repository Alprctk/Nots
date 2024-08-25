//
//  MetinBicimiGorunumu.swift
//  Nots
//
//  Created by Alper Çatak on 17.07.2024.
//

import SwiftUI

struct MetinBicimiGorunumu: View {
    @Binding var text: String
    @Binding var selectedFont: Font
    @Binding var selectedSize: CGFloat
    @Binding var selectedColor: Color
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            ColorPicker("Renk", selection: $selectedColor)
                .labelsHidden()
                .padding()

            Picker("Font", selection: $selectedFont) {
                Text("Title").tag(Font.title)
                Text("Headline").tag(Font.headline)
                Text("Body").tag(Font.body)
                Text("Caption").tag(Font.caption)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Slider(value: $selectedSize, in: 10...30, step: 1) {
                Text("Size")
            }
            .padding()

            Button("Tamam") {
                // İşlemi tamamla ve kapat
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
    }
}
