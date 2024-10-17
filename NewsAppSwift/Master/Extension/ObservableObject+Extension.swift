//
//  ObservableObject+Extension.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 03/07/24.
//

import SwiftUI

extension ObservableObject {
    func binding<T>(for keyPath: ReferenceWritableKeyPath<Self, T>) -> Binding<T> {
        Binding(
            get: { self[keyPath: keyPath] },
            set: { self[keyPath: keyPath] = $0 }
        )
    }
}
