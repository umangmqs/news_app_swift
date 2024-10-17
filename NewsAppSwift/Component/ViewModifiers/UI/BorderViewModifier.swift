//
//  BorderViewModifier.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 28/06/24.
//

import SwiftUI

private struct BorderViewModifier: ViewModifier {
    var radius: CGFloat
    var color: Color
    var lineWidth: CGFloat

    func body(content: Content) -> some View {
        content
            .corner(radius: radius)
            .overlay {
                RoundedRectangle(cornerRadius: radius)
                    .stroke(color, lineWidth: lineWidth)
            }
    }
}

extension View {
    func border(radius: CGFloat, color: Color, lineWidth: CGFloat = 1) -> some View {
        modifier(BorderViewModifier(radius: radius, color: color, lineWidth: lineWidth))
    }
}
