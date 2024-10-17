//
//  LanguageView.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 17/10/24.
//

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
                title: "Language".localized()
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
        .environment(\.locale, languageViewModel.selectedLocale)
        .environment(
            \.layoutDirection,
            languageViewModel.selectedLocale.identifier == "ar"
                ? .rightToLeft : .leftToRight
        )
        .navigationBarBackButtonHidden()
        .padding(.horizontal, 16.aspectRatio)

    } 
}
