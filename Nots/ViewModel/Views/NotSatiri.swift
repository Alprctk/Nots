//
//  NotSatiri.swift
//  Nots
//
//  Created by Alper Çatak on 16.07.2024.
//



import SwiftUI

struct NotSatiri: View {
    let not: Not
    @ObservedObject var viewModel: NotlarViewModel
    @Binding var secimModu: Bool

    var body: some View {
        HStack {
            if secimModu {
                Image(systemName: viewModel.selectedNotes.contains(not.id) ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(viewModel.selectedNotes.contains(not.id) ? .blue : .gray)
            }
            VStack(alignment: .leading) {
                Text(not.baslik)
                    .font(.headline)
                    .foregroundColor(.gray)
                Text(not.icerik)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1) // Tek satırda görünmesini sağlamak için
                    .truncationMode(.tail) // Uzun metinler için üç nokta eklenir
            }
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if secimModu {
                if viewModel.selectedNotes.contains(not.id) {
                    viewModel.selectedNotes.remove(not.id)
                } else {
                    viewModel.selectedNotes.insert(not.id)
                }
            } else {
                viewModel.editingNote = not
                viewModel.showEditNoteView = true
                viewModel.mevcutNotBasligi = not.baslik
                viewModel.mevcutNotIcerigi = not.icerik
                viewModel.mevcutNotRengi = not.renk
            }
        }
        .background(viewModel.selectedNotes.contains(not.id) ? Color.blue.opacity(0.2) : Color.clear)
    }
}
