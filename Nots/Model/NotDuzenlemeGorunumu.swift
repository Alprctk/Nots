//
//  NotDuzenlemeGorunumu.swift
//  Nots
//
//  Created by Alper Çatak on 16.07.2024.
//

import SwiftUI

struct NotDuzenlemeGorunumu: View {
    @ObservedObject var viewModel: NotlarViewModel
    @Environment(\.presentationMode) var presentationMode
    var not: Not

    @State private var baslik: String
    @State private var icerik: String

    init(viewModel: NotlarViewModel, not: Not) {
        self.viewModel = viewModel
        self.not = not
        _baslik = State(initialValue: not.baslik)
        _icerik = State(initialValue: not.icerik)
    }

    var body: some View {
        NavigationView {
            VStack {
                TextField("Başlık", text: $baslik)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)

                TextEditor(text: $icerik)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)

                Spacer()
            }
            .navigationTitle("Notu Düzenle")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Vazgeç") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet") {
                        if let index = viewModel.notlar.firstIndex(where: { $0.id == not.id }) {
                            viewModel.notlar[index].baslik = baslik
                            viewModel.notlar[index].icerik = icerik
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct NotDuzenlemeGorunumu_Previews: PreviewProvider {
    static var previews: some View {
        NotDuzenlemeGorunumu(viewModel: NotlarViewModel(), not: Not(baslik: "Örnek Başlık", icerik: "Örnek İçerik", sira: 1))
    }
}
