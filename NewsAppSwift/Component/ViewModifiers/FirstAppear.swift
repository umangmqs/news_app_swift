//
//  FirstAppear.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 09/07/24.
//

import SwiftUI

struct FirstAppear: ViewModifier {
    @State private var hasAppeared = false
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear {
                if !hasAppeared {
                    action()
                    hasAppeared = true
                }
            }
    }
}

extension View {
    func onFirstAppear(perform action: @escaping () -> Void) -> some View {
        self.modifier(FirstAppear(action: action))
    }
}
