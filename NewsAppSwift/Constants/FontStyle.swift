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
                return "Montserrat-Regular"
            case .medium:
                return "Montserrat-Medium"
            case .semibold:
                return "Montserrat-SemiBold"
            case .bold:
                return "Montserrat-Bold"
                
            case .custom(let name):
                return name
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
                return "Lato-Regular"
            case .medium:
                return "Lato-Medium"
            case .bold:
                return "Lato-Bold"
                
            case .custom(let name):
                return name
            }
        }
    }
    
    static func montserrat(_ type: MontserratFont = .regular, size: CGFloat) -> Font {
        return .custom(type.value, size: (Double(size)).aspectRatio)
    } 
    
    static func lato(_ type: LatoFont = .regular, size: CGFloat) -> Font {
        return .custom(type.value, size: (Double(size)).aspectRatio)
    }
}
 
