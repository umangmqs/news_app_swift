//
//  FontStyle.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 28/06/24.
//

import SwiftUI

extension Font {
    enum MontserratFont {
        case regular
        case medium
        case semibold
        case bold
        case custom(String)

        var value: String {
            switch self {
            case .regular:
                "Montserrat-Regular"
            case .medium:
                "Montserrat-Medium"
            case .semibold:
                "Montserrat-SemiBold"
            case .bold:
                "Montserrat-Bold"
            case let .custom(name):
                name
            }
        }
    }

    enum LatoFont {
        case regular
        case medium
        case bold
        case custom(String)

        var value: String {
            switch self {
            case .regular:
                "Lato-Regular"
            case .medium:
                "Lato-Medium"
            case .bold:
                "Lato-Bold"
            case let .custom(name):
                name
            }
        }
    }

    static func montserrat(_ type: MontserratFont = .regular, size: CGFloat) -> Font {
        .custom(type.value, size: Double(size).aspectRatio)
    }

    static func lato(_ type: LatoFont = .regular, size: CGFloat) -> Font {
        .custom(type.value, size: Double(size).aspectRatio)
    }
}
