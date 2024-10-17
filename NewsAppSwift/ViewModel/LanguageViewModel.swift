//
//  LanguageViewModel.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 17/10/24.
//

import SwiftUI

class LanguageViewModel: ObservableObject {
    @Published var selectedLocale: Locale = Locale(identifier: "en")
    
    @Published var arrLanguage: [MDLLanguage] = [
        MDLLanguage(
            languageName: "English", image: .en, selected: false,
            locale: Locale(identifier: "en")),
        MDLLanguage(
            languageName: "Arabic", image: .ar, selected: false,
            locale: Locale(identifier: "ar")),
        MDLLanguage(
            languageName: "Italian", image: .it, selected: false,
            locale: Locale(identifier: "it")),
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
            
            UserDefaults.standard.set(locale.identifier, forKey: StorageKey.appLocale)
        }
    }
    
    func getSelectedLanguage() {
        let localeIdentier = UserDefaults.standard.value(forKey: StorageKey.appLocale) as? String ?? "en"
//        var _ = arrLanguage.filter({localeIdentier.contains($0.locale.identifier)}).first?.selected = true
//        res?.selected = true
        
        if let firstIndex = arrLanguage.firstIndex(where: {localeIdentier.contains($0.locale.identifier)}) {
            arrLanguage[firstIndex].selected = true
            selectedLocale = arrLanguage[firstIndex].locale
        }
    }
}
