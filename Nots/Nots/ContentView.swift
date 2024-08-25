//
//  ContentView.swift
//  Nots
//
//  Created by Alper Çatak on 16.07.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        IcerikGorunumu(viewModel: NotlarViewModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
