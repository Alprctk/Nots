//
//  Note.swift
//  Nots
//
//  Created by Alper Çatak on 16.07.2024.
//

import SwiftUI

struct Not: Identifiable {
    var id: UUID
    var baslik: String
    var icerik: String
    var renk: Color
}
