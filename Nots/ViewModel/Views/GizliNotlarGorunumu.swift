//
//  GizliNotlarGorunumu.swift
//  Nots
//
//  Created by Alper Çatak on 16.07.2024.
//

import SwiftUI

struct GizliNotlarGorunumu: View {
    @ObservedObject var viewModel: NotlarViewModel
    @State private var duzenlemeModu = false
    @State private var duzenlenecekNot: Not?
    @State private var silmeOnayiGoster = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.gizliNotlar) { not in
                    NotSatiri(not: not, viewModel: viewModel, secimModu: .constant(false))
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            Button {
                                viewModel.notuGizliKaldir(not: not)
                            } label: {
                                Label("Gizli Kaldır", systemImage: "eye")
                            }
                            .tint(.blue)
                        }
                        .swipeActions(edge: .trailing) {
                            Button {
                                silmeOnayiGoster = true
                                duzenlenecekNot = not
                            } label: {
                                Label("Sil", systemImage: "trash")
                            }
                            .tint(.red)

                            Button {
                                duzenlemeModu = true
                                duzenlenecekNot = not
                                viewModel.mevcutNotBasligi = not.baslik
                                viewModel.mevcutNotIcerigi = not.icerik
                                viewModel.mevcutNotRengi = not.renk
                            } label: {
                                Label("Düzenle", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                }
                .onDelete(perform: sil)
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Gizli Notlar")
            .sheet(isPresented: $duzenlemeModu, onDismiss: {
                duzenlenecekNot = nil
            }) {
                if let not = duzenlenecekNot {
                    NotEklemeGorunumu(viewModel: viewModel, not: not)
                }
            }
            .confirmationDialog("Silmek istediğinizden emin misiniz?", isPresented: $silmeOnayiGoster) {
                Button("Evet", role: .destructive) {
                    if let not = duzenlenecekNot {
                        viewModel.notlariSil(not: not)
                    }
                }
                Button("Vazgeç", role: .cancel) {}
            }
        }
    }

    private func sil(at offsets: IndexSet) {
        for index in offsets {
            let not = viewModel.gizliNotlar[index]
            viewModel.notlariSil(not: not)
        }
    }
}

struct GizliNotlarGorunumu_Previews: PreviewProvider {
    static var previews: some View {
        GizliNotlarGorunumu(viewModel: NotlarViewModel())
    }
}
