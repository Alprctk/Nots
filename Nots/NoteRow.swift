//
//  NoteRow.swift
//  Nots
//
//  Created by Alper Çatak on 16.07.2024.
//

import SwiftUI

struct NoteRow: View {
    let note: Note
    @ObservedObject var viewModel: NotesViewModel
    @Binding var isSelecting: Bool

    var body: some View {
        HStack {
            if isSelecting {
                Image(systemName: viewModel.selectedNotes.contains(note.id) ? "checkmark.circle.fill" : "circle")
                    .onTapGesture {
                        if viewModel.selectedNotes.contains(note.id) {
                            viewModel.selectedNotes.remove(note.id)
                        } else {
                            viewModel.selectedNotes.insert(note.id)
                        }
                    }
            }
            Text(note.text)
            Spacer()
        }
        .contentShape(Rectangle())
    }
}

struct NoteRow_Previews: PreviewProvider {
    static var previews: some View {
        NoteRow(note: Note(text: "Sample Note", order: 1), viewModel: NotesViewModel(), isSelecting: .constant(false))
    }
}
