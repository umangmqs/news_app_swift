//
//  Router.swift
//  NavigationDemo
//
//  Created by MQF-6 on 02/04/24.
//

import SwiftUI

enum Destination: Codable, Hashable {
    case onboarding
    case login
    case signup
    case forgotPassword
    case changePassword
    case verifyOtp
    case tabbar
    case newsDetail
    case seeAllNews
    case languegeSelection
    case noInternet
}

final class Router: ObservableObject {

    @Published var navPath = NavigationPath()

    func push(to destination: Destination) {
        navPath.append(destination)
    }

    func pop() {
        navPath.pop()
    }

    func popToRoot() {
        navPath.popToRoot()
    }

    func popToView(destination: Destination) {
        navPath.popTo(item: destination)
    }
}

extension NavigationPath {
    public static var resolvedItemTypes: [String: Codable.Type] = [:]
    public static func register<T: Codable>(_ types: T.Type...) {
        types.forEach { type in
            resolvedItemTypes[String(describing: type)] = type
        }
    }

    public var resolvedItems: [Codable] {
        guard let codable = self.codable,
            let json = try? JSONEncoder().encode(codable),
            let containner = try? JSONDecoder().decode(
                NavigationItemContainer.self, from: json)
        else { return [] }
        return containner.items
    }

    public mutating func popTo(item: Codable) {
        if let index = resolvedItems.firstIndex(where: {
            compare(item, $0)
        }) {
            self.removeLast(self.count - 1 - index)
        }
    }

    public mutating func popToRoot() {
        self.removeLast(self.count)
    }

    public mutating func pop() {
        self.removeLast()
    }

    private func compare(_ item1: Codable, _ item2: Codable) -> Bool {
        let isSameType = type(of: item1) == type(of: item2)
        let isSameValue =
            (try? JSONEncoder().encode(item1))
            == (try? JSONEncoder().encode(item2))
        return isSameType && isSameValue
    }

    private struct NavigationItemContainer: Decodable {
        let items: [Codable]
        init(items: [Codable]) {
            self.items = items
        }
        init(from decoder: Decoder) throws {
            var container = try decoder.unkeyedContainer()
            var items = [Codable]()
            let appName =
                (Bundle.main.object(forInfoDictionaryKey: "CFBundleName")
                    as? String ?? "") + ""
            let appNameSnakeCase = appName.replacingOccurrences(
                of: "-", with: "_")
            while !container.isAtEnd {
                let typeString = try container.decode(String.self)
                    .replacingOccurrences(of: appName, with: "")
                    .replacingOccurrences(of: appNameSnakeCase, with: "")
                let jsonString = try container.decode(String.self)
                if let jsonData = jsonString.data(using: .utf8) {
                    if let itemType = NavigationPath.resolvedItemTypes[
                        typeString] {
                        let decodedItem = try JSONDecoder().decode(
                            itemType, from: jsonData)
                        items.append(decodedItem)
                    }
                }
            }

            self.items = items
        }
    }
}
