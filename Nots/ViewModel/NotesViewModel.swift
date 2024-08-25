//
//  NotesViewModel.swift
//  Nots
//
//  Created by Alper Çatak on 16.07.2024.
//

import Foundation
import SwiftUI

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var selectedNotes: Set<UUID> = []
    @Published var currentNoteText: String = ""
    @Published var showDeleteConfirmation = false

    func addNote() {
        let order = (notes.max(by: { $0.order < $1.order })?.order ?? 0) + 1
        let newNote = Note(text: "\(order). Yeni Not", order: order)
        notes.append(newNote)
        currentNoteText = ""
    }
    
    func saveCurrentNote() {
        if !currentNoteText.isEmpty {
            let order = (notes.max(by: { $0.order < $1.order })?.order ?? 0) + 1
            let newNote = Note(text: currentNoteText, order: order)
            notes.append(newNote)
            currentNoteText = ""
        }
    }

    func deleteSelectedNotes() {
        notes.removeAll { note in
            selectedNotes.contains(note.id)
        }
        selectedNotes.removeAll()
    }

    func pinUnpin(note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index].isPinned.toggle()
        }
    }
    
    func shareNotes() -> [String] {
        notes.filter { selectedNotes.contains($0.id) }.map { $0.text }
    }
}
