//
//  MDLLanguage.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 17/10/24.
//

import SwiftUI
import LanguageManager_iOS

struct MDLLanguage: Identifiable {
    var id: String = UUID().uuidString
    var languageName: String
    var image: ImageResource
    var locale: Languages
    var selected: Bool = false

    init(
        id: String = UUID().uuidString, languageName: String,
        image: ImageResource, selected: Bool = false, locale: Languages
    ) {
        self.id = id
        self.languageName = languageName
        self.image = image
        self.selected = selected
        self.locale = locale
    }
}
