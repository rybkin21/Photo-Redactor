//
//  GoogleSignInButton.swift
//  Photo Redactor
//
//  Created by Ivan Rybkin on 04.03.2025.
//

import SwiftUI

struct GoogleSignInButton: View {

    var action: () -> Void

    var body: some View {
        HStack() {
            Button {
                action()
            } label: {
                Image("google")
                    .resizable()
                    .frame(width: 24, height: 24)

                Text("Sign in with Google")

            }
            .fontWeight(.bold)
            .foregroundStyle(Color.pink.opacity(0.8))
            .padding(.vertical)
            .frame(width: UIScreen.main.bounds.width - 30)
            .background(Color.white)
            .clipShape(Capsule())
        }

    }
}

#Preview {
    GoogleSignInButton(action: {})
}
