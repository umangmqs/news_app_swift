//
//  FirstAppear.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 09/07/24.
//

import SwiftUI

struct FirstAppear: ViewModifier {
    @State private var hasAppeared = false
    let action: () async -> Void

    func body(content: Content) -> some View {
        content
            .task {
                if !hasAppeared {
                    await action()
                    hasAppeared = true
                }
            }
    }
}

extension View {
    func onFirstAppear(perform action: @escaping () -> Void) -> some View {
        modifier(FirstAppear(action: action))
    }
}
