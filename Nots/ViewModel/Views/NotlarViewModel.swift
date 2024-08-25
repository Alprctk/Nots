//
// NotlarViewModel.swift
// Nots
//
// Created by Alper Çatak on 16.07.2024.
//


import Foundation
import SwiftUI

class NotlarViewModel: ObservableObject {
    @Published var notlar: [Not] = []
    @Published var gizliNotlar: [Not] = []
    @Published var mevcutNotBasligi: String = ""
    @Published var mevcutNotIcerigi: String = ""
    @Published var mevcutNotRengi: Color = .white
    @Published var selectedNotes = Set<UUID>()
    @Published var showHiddenNotesView = false
    @Published var editingNote: Not?
    @Published var showEditNoteView: Bool = false

    func tumNotlariAl() -> [Not] {
        return notlar
    }

    func notEkle(baslik: String, icerik: String, renk: Color) {
        let yeniNot = Not(id: UUID(), baslik: baslik, icerik: icerik, renk: renk)
        notlar.append(yeniNot)
        temizle()
    }

    func notuGuncelle(not: Not, baslik: String, icerik: String, renk: Color) {
        if let index = notlar.firstIndex(where: { $0.id == not.id }) {
            notlar[index].baslik = baslik
            notlar[index].icerik = icerik
            notlar[index].renk = renk
            temizle()
        }
    }

    func notlariSil(not: Not) {
        notlar.removeAll { $0.id == not.id }
        gizliNotlar.removeAll { $0.id == not.id }
    }

    func notuGizle(not: Not) {
        if let index = notlar.firstIndex(where: { $0.id == not.id }) {
            gizliNotlar.append(not)
            notlar.remove(at: index)
        }
    }

    func notuGizliKaldir(not: Not) {
        if let index = gizliNotlar.firstIndex(where: { $0.id == not.id }) {
            notlar.append(not)
            gizliNotlar.remove(at: index)
        }
    }

    func notlariPaylas() -> [Any] {
        return notlar.filter { selectedNotes.contains($0.id) }
            .map { "\($0.baslik)\n\($0.icerik)" }
    }

    func kaydiGeriAl() {
        // Geri al işlemi
    }

    func temizle() {
        mevcutNotBasligi = ""
        mevcutNotIcerigi = ""
        mevcutNotRengi = .white
    }
}
