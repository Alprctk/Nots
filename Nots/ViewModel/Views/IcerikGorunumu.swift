//  IcerikGorunumu.swift
//  Nots
//
//  Created by Alper Çatak on 16.07.2024.
//

import SwiftUI
import LocalAuthentication

struct IcerikGorunumu: View {
    @ObservedObject var viewModel: NotlarViewModel
    @State private var notEklemeGorunumuAcik = false
    @State private var secimModu = false
    @State private var paylasmaGorunumuAcik = false
    @State private var silmeOnayiGoster = false
    @State private var duzenlemeModu = false
    @State private var duzenlenecekNot: Not?
    @State private var geriAlAlertGoster = false
    @State private var gizliNotlarGorunumuAcik = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.tumNotlariAl()) { not in
                        NotSatiri(not: not, viewModel: viewModel, secimModu: $secimModu)
                            .onTapGesture {
                                if !secimModu {
                                    duzenlemeModu = true
                                    duzenlenecekNot = not
                                    viewModel.mevcutNotBasligi = not.baslik
                                    viewModel.mevcutNotIcerigi = not.icerik
                                    viewModel.mevcutNotRengi = not.renk
                                }
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                Button {
                                    viewModel.notuGizle(not: not)
                                } label: {
                                    Label("Gizle", systemImage: "eye.slash")
                                }
                                .tint(.gray)
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
                                } label: {
                                    Label("Düzenle", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                    }
                    .onDelete(perform: sil)
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Notlar")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            secimModu.toggle()
                            if !secimModu {
                                viewModel.selectedNotes.removeAll()
                            }
                        }) {
                            Text(secimModu ? "Bitti" : "Seç")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            Button(action: {
                                authenticateAndShowHiddenNotes()
                            }) {
                                Image(systemName: "eye")
                            }
                            Button(action: {
                                notEklemeGorunumuAcik = true
                            }) {
                                Image(systemName: "plus")
                            }
                            .sheet(isPresented: $notEklemeGorunumuAcik) {
                                NotEklemeGorunumu(viewModel: viewModel)
                            }
                        }
                    }
                }

                if secimModu {
                    HStack {
                        Button(action: {
                            silSelectedNotes()
                        }) {
                            Image(systemName: "trash")
                                .padding()
                        }
                        Spacer()
                        Button(action: {
                            paylasmaGorunumuAcik = true
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .padding()
                        }
                    }
                    .background(Color.gray.opacity(0.2))
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
            .onAppear {
                let notificationCenter = NotificationCenter.default
                notificationCenter.addObserver(forName: UIDevice.shakeNotification, object: nil, queue: .main) { _ in
                    geriAlAlertGoster = true
                }
            }
            .sheet(isPresented: $paylasmaGorunumuAcik) {
                let paylasilacakNotlar = viewModel.notlariPaylas()
                AktiviteGorunumu(aktiviteOgeleri: paylasilacakNotlar)
            }
            .sheet(isPresented: $duzenlemeModu, onDismiss: {
                duzenlenecekNot = nil
            }) {
                if let not = duzenlenecekNot {
                    NotEklemeGorunumu(viewModel: viewModel, not: not)
                }
            }
            .alert(isPresented: $geriAlAlertGoster) {
                Alert(
                    title: Text("Geri Al"),
                    message: Text("Son işlemi geri almak istiyor musunuz?"),
                    primaryButton: .destructive(Text("Geri Al")) {
                        viewModel.kaydiGeriAl()
                    },
                    secondaryButton: .cancel(Text("İptal"))
                )
            }
        }
        .sheet(isPresented: $gizliNotlarGorunumuAcik) {
            GizliNotlarGorunumu(viewModel: viewModel)
        }
    }

    private func sil(at offsets: IndexSet) {
        for index in offsets {
            viewModel.notlar.remove(at: index)
        }
    }

    private func silSelectedNotes() {
        silmeOnayiGoster = true
    }

    private func authenticateAndShowHiddenNotes() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Gizli notları görmek için kimlik doğrulaması yapın."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        gizliNotlarGorunumuAcik = true
                    } else {
                        // Kimlik doğrulama başarısız
                    }
                }
            }
        } else {
            // FaceID/TouchID kullanılamaz
        }
    }
}

struct IcerikGorunumu_Previews: PreviewProvider {
    static var previews: some View {
        IcerikGorunumu(viewModel: NotlarViewModel())
    }
}
