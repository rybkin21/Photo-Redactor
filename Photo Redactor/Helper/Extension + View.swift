//
//  Extension + View.swift
//  Photo Redactor
//
//  Created by Ivan Rybkin on 04.03.2025.
//

import SwiftUI

extension View {
    func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }

        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }

        return root
    }
}
