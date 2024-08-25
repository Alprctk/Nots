//
//  AktiviteGorunumu.swift .swift
//  Nots
//
//  Created by Alper Çatak on 17.07.2024.
//

import SwiftUI

struct AktiviteGorunumu: UIViewControllerRepresentable {
    let aktiviteOgeleri: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: aktiviteOgeleri, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
