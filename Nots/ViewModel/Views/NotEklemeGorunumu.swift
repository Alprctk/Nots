//
//  NotEklemeGorunumu.swift
//  Nots
//
//  Created by Alper Çatak on 16.07.2024.
//

//
//  NotEklemeGorunumu.swift
//  Nots
//
//  Created by Alper Çatak on 16.07.2024.
//

import SwiftUI
import VisionKit
import Vision

struct NotEklemeGorunumu: View {
    @ObservedObject var viewModel: NotlarViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var baslik = ""
    @State private var icerik = ""
    @State private var renk: Color = .white  // Default renk eklenmiştir.
    @State private var sabitlenmis = false
    @State private var tarananMetin = ""
    @State private var selectedFont: String = "Body"
    @State private var selectedSize: Double = 16
    @State private var selectedColor: Color = .primary // Default renk eklenmiştir.
    @State private var showingScanner = false

    var not: Not?

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        if let not = not {
                            viewModel.notuGuncelle(not: not, baslik: baslik, icerik: icerik, renk: renk)
                        } else {
                            viewModel.notEkle(baslik: baslik, icerik: icerik, renk: renk)
                        }
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Kaydet")
                            .bold()
                    }
                    .padding()
                }

                TextField("Başlık", text: $baslik)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)

                TextEditor(text: $icerik)
                    .font(getFont(selectedFont, size: CGFloat(selectedSize)))
                    .foregroundColor(selectedColor) // Metin rengi ayarlandı.
                    .padding()
                    .border(Color.gray, width: 1)
                    .cornerRadius(8)
                    .padding(.horizontal)

                Spacer()

                HStack {
                    Button(action: {
                        showingScanner = true
                    }) {
                        Image(systemName: "camera")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .sheet(isPresented: $showingScanner) {
                        MetinTaraView(tarananMetin: $icerik) // Burada taranan metni doğrudan icerik değişkenine ekliyoruz
                    }

                    ColorPicker("Renk", selection: $selectedColor) // Renk seçici eklendi.
                        .labelsHidden()
                        .padding()

                    VStack {
                        Picker("Yazı Tipi", selection: $selectedFont) {
                            Text("Title").tag("Title")
                            Text("Headline").tag("Headline")
                            Text("Body").tag("Body")
                            Text("Caption").tag("Caption")
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        Picker("Boyut", selection: $selectedSize) {
                            ForEach(10..<31) { size in
                                Text("\(size)").tag(Double(size))
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal)
            }
            .navigationTitle(not != nil ? "Notu Düzenle" : "Yeni Not")
            .onAppear {
                if let not = not {
                    baslik = not.baslik
                    icerik = not.icerik
                    renk = not.renk
                   
                }
            }
        }
    }

    private func getFont(_ font: String, size: CGFloat) -> Font {
        switch font {
        case "Title":
            return .system(size: size, weight: .bold, design: .default)
        case "Headline":
            return .system(size: size, weight: .semibold, design: .default)
        case "Body":
            return .system(size: size, weight: .regular, design: .default)
        case "Caption":
            return .system(size: size, weight: .light, design: .default)
        default:
            return .body
        }
    }
}

struct NotEklemeGorunumu_Previews: PreviewProvider {
    static var previews: some View {
        NotEklemeGorunumu(viewModel: NotlarViewModel())
    }
}
