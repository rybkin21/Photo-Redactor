//
//  LoadingView.swift
//  Photo Redactor
//
//  Created by Ivan Rybkin on 03.03.2025.
//

import SwiftUI

struct LoadingView: View {

    @State var animation = false

    var body: some View {

        VStack {

            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(Color.pink, lineWidth: 8)
                .rotationEffect(.init(degrees: animation ? 360 : 0))
                .frame(width: 75, height: 75)
                .padding(50)
        }
        .background(Color.white)
        .cornerRadius(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.4).ignoresSafeArea())
        .onAppear {
            withAnimation(Animation.linear(duration: 1)) {

                animation.toggle()
            }
        }
    }
}
