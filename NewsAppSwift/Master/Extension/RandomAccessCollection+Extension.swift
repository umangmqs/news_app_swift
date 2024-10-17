//
//  RandomAccessCollection+Extension.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 23/07/24.
//

import Foundation

public extension RandomAccessCollection where Self.Element: Identifiable {
    func isLastItem(_ item: some Identifiable) -> Bool {
        guard !isEmpty else {
            return false
        }

        guard let itemIndex = lastIndex(where: { AnyHashable($0.id) == AnyHashable(item.id) }) else {
            return false
        }

        let distance = distance(from: itemIndex, to: endIndex)
        return distance == 1
    }

    func isThresholdItem(
        offset: Int,
        item: some Identifiable
    ) -> Bool {
        guard !isEmpty else {
            return false
        }

        guard let itemIndex = lastIndex(where: { AnyHashable($0.id) == AnyHashable(item.id) }) else {
            return false
        }

        let distance = distance(from: itemIndex, to: endIndex)
        let offset = offset < count ? offset : count - 1
        return offset == (distance - 1)
    }
}
