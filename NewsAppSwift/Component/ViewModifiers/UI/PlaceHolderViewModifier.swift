//
//  PlaceHolderViewModifier.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 28/06/24.
//

import SwiftUI

struct PlaceHolderViewModifier: ViewModifier {
    var placeHolder: String
    var show: Bool
    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if show {
                Text(LocalizedStringKey(placeHolder))
                    .font(.lato(.regular, size: 16))
                    .foregroundStyle(.secondary.opacity(0.6))
            }
            content
        }
    }
}

extension View {
    func placeHolder(_ holder: String, show: Bool) -> some View {
        modifier(PlaceHolderViewModifier(placeHolder: holder, show: show))
    }
}
