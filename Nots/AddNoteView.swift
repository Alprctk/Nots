//
//  AddNoteView.swift
//  Nots
//
//  Created by Alper Çatak on 16.07.2024.
//

import SwiftUI

struct AddNoteView: View {
    @ObservedObject var viewModel: NotesViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $viewModel.currentNoteText)
                    .padding()
                Spacer()
            }
            .navigationTitle("Yeni Not")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Vazgeç") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet") {
                        viewModel.saveCurrentNote()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteView(viewModel: NotesViewModel())
    }
}
