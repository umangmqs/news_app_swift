//
//  LanguageViewModel.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 17/10/24.
//

import SwiftUI
import LanguageManager_iOS

class LanguageViewModel: ObservableObject {
    @Published var selectedLocale: Languages = .en
    
    @Published var arrLanguage: [MDLLanguage] = [
        MDLLanguage(
            languageName: "English", image: .en, selected: false,
            locale: Languages.en),
        MDLLanguage(
            languageName: "Arabic", image: .ar, selected: false,
            locale: Languages.ar),
        MDLLanguage(
            languageName: "Italian", image: .it, selected: false,
            locale: Languages.it),
    ]
    
    func updateNewLanguage(at model: MDLLanguage) {
        withAnimation(.easeInOut(duration: 0.4)) {
            arrLanguage = arrLanguage.map { language in
                var updatedLanguage = language
                updatedLanguage.selected = (language.id == model.id)
                return updatedLanguage
            }
            
            guard let locale = arrLanguage.first(where: {$0.selected == true})?.locale else {
                AppPrint.debugPrint("Retured")
                return
            }
              
            selectedLocale = locale
            
            LanguageManager.shared.setLanguage(language: locale)
        
            AppPrint.debugPrint(LanguageManager.shared.currentLanguage)
        }
    }
    
    func getSelectedLanguage() {
        if let index = arrLanguage.firstIndex(where: {$0.locale == LanguageManager.shared.currentLanguage}) {
            DispatchQueue.main.async {
                self.arrLanguage[index].selected = true
            }
        }
    }
}
