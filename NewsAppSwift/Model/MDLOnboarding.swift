//
//  MDLOnboarding.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 02/07/24.
//

import Foundation

struct MDLOnboarding: Identifiable, Hashable {
    var id: UUID = .init()
    var title: String
    var subTitle: String
    var image: String
}
