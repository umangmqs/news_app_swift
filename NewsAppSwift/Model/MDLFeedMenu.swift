//
//  MDLFeedMenu.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 09/07/24.
//

import Foundation

class MDLFeedMenu: Identifiable, ObservableObject {
    var id: UUID = .init()
    var title: String
    @Published var selected: Bool

    init(title: String, selected: Bool) {
        self.title = title
        self.selected = selected
    }
}
