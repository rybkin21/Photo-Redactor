//
//  TextBox.swift
//  Photo Redactor
//
//  Created by Ivan Rybkin on 06.03.2025.
//

import SwiftUI
import PencilKit

struct TextBox: Identifiable {

    var id = UUID().uuidString
    var text: String = ""
    var isBold: Bool = false

    var offset: CGSize = .zero
    var lastOffset: CGSize = .zero
    var textColor: Color = .white

    var isAdded: Bool = false
}
