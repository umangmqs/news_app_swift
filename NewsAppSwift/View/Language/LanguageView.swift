//
//  LanguageView.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 17/10/24.
//

import LanguageManager_iOS
import SwiftUI

struct LanguageView: View {
    @Environment(\.dismiss) private var dismiss

    @StateObject var languageViewModel: LanguageViewModel

    var body: some View {
        VStack {
            AppNavigationBar(
                type: .titleAndLeading,
                searchText: .constant(""),
                leadingAction: {
                    dismiss.callAsFunction()
                },
                leadingImage: .icBack,
                title: "Language".localiz()
            )

            VStack {
                ForEach(languageViewModel.arrLanguage, id: \.id) { item in
                    LanguageCell(item: item) {
                        languageViewModel.updateNewLanguage(at: item)
                    }
                }
            }

            Spacer()
        }
        .onAppear(perform: {
            languageViewModel.getSelectedLanguage()
        })
        .environment(\.locale, LanguageManager.shared.appLocale)
        .environment(
            \.layoutDirection,
            LanguageManager.shared.isRightToLeft ? .rightToLeft : .leftToRight
        )
        .navigationBarBackButtonHidden()
        .padding(.horizontal, 16.aspectRatio)
    }
}
