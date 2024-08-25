//
//  MetinTaraView.swift
//  Nots
//
//  Created by Alper Çatak on 16.07.2024.
//

import SwiftUI
import VisionKit
import Vision

struct MetinTaraView: UIViewControllerRepresentable {
    @Binding var tarananMetin: String
    @Environment(\.presentationMode) var presentationMode

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = context.coordinator
        return scannerViewController
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}

    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        let parent: MetinTaraView

        init(parent: MetinTaraView) {
            self.parent = parent
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            guard scan.pageCount > 0 else {
                controller.dismiss(animated: true)
                return
            }

            let requestHandler = VNImageRequestHandler(cgImage: scan.imageOfPage(at: 0).cgImage!, options: [:])
            let request = VNRecognizeTextRequest { (request, error) in
                guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
                let recognizedText = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
                DispatchQueue.main.async {
                    self.parent.tarananMetin = recognizedText
                    self.parent.presentationMode.wrappedValue.dismiss()
                }
            }
            request.recognitionLevel = .accurate
            do {
                try requestHandler.perform([request])
            } catch {
                print("Text recognition error: \(error)")
            }
        }
    }
}
