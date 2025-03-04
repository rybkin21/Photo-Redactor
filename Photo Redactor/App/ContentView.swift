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

                VStack(spacing: 25) {

                    Text("Logged In As \(Auth.auth().currentUser?.email ?? "")")

                    Button(action: model.logOut, label: {
                        Text("LogOut")
                            .fontWeight(.bold)
                    })
                }
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
