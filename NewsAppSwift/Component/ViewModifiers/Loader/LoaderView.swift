//
//  LoaderView.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 08/07/24.
//

import LoaderUI
import SwiftUI

struct LoaderView: ViewModifier {
    var isLoading = false

    init(isLoading: Bool = false) {
        self.isLoading = isLoading
    }

    func body(content: Content) -> some View {
        content
            .overlay {
                if isLoading {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            CubeTransition()
                                .frame(width: 60.aspectRatio, height: 60.aspectRatio)
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        Spacer()
                    }
                    .background(.black.opacity(0.3))
                    .ignoresSafeArea()
                }
            }
    }
}

extension View {
    func loader(loading: Bool) -> some View {
        modifier(LoaderView(isLoading: loading))
            .disabled(loading)
    }
}
