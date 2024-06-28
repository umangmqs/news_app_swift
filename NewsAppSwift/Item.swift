//
//  Item.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 28/06/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
