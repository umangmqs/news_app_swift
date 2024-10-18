//
//  CornerRadiusViewModifier.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 28/06/24.
//

import SwiftUI

private struct CornerRadiusViewModifier: ViewModifier {
    var radius: CGFloat

    func body(content: Content) -> some View {
        content
            .clipShape(.rect(cornerRadius: radius))
    }
}

extension View {
    func corner(radius: CGFloat) -> some View {
        modifier(CornerRadiusViewModifier(radius: radius))
    }
}

extension View {
    func innerShadow(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat)
        -> some View {
        self
            .overlay(
                self
                    .mask(self)
                    .overlay(
                        self
                            .mask(self)
                            .shadow(color: color, radius: radius, x: x, y: y)
                            .blendMode(.sourceAtop)
                    )
                    .shadow(color: color, radius: radius, x: -x, y: -y)
                    .blendMode(.sourceAtop)
            )
    }
}
