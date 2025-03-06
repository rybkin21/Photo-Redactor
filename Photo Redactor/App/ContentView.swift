//
//  ContentView.swift
//  Photo Redactor
//
//  Created by Ivan Rybkin on 03.03.2025.
//

import SwiftUI
import Firebase

struct ContentView: View {

    @AppStorage("log_Status") var status = false
    @StateObject var model = ModelData()

    var body: some View {

        ZStack {
            if status {
                RedactorScreen()
            }
            else {
                LoginScreen(model: model)
            }
        }
    }
}

#Preview {
    ContentView()
}
