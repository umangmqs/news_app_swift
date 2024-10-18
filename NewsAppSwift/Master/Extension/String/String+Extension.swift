//
//  String+Extension.swift
//
//  Created by MultiQoS on 05/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SwiftUICore
import UIKit

extension String {
    func removeAsterisks() -> String {
        replacingOccurrences(of: "**", with: "")
    }
}

// MARK: - Extension of String For Converting it TO Int AND URL.

extension String {
    /// A Computed Property (only getter) of Int For getting the Int? value from String.
    /// This Computed Property (only getter) returns Int? , it means this Computed Property (only getter) return nil value also , while using this Computed Property (only getter) please use if let. If you are not using if let and if this Computed Property (only getter) returns nil and when you are trying to unwrapped this value("Int!") then application will crash.
    var toInt: Int? {
        Int(self)
    }

    var toDouble: Double? {
        Double(self)
    }

    var toFloat: Float? {
        Float(self)
    }

    /// A Computed Property (only getter) of URL For getting the URL from String.
    /// This Computed Property (only getter) returns URL? , it means this Computed Property (only getter) return nil value also , while using this Computed Property (only getter) please use if let. If you are not using if let and if this Computed Property (only getter) returns nil and when you are trying to unwrapped this value("URL!") then application will crash.
    var toURL: URL? {
        URL(string: self)
    }
}

extension String {
    var trim: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var isBlank: Bool {
        trim.isEmpty
    }

    var isAlphanumeric: Bool {
        !isBlank && rangeOfCharacter(from: .alphanumerics) != nil
    }

    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let predicate = NSPredicate(
            format: "SELF MATCHES %@",
            emailRegEx
        )

        return predicate.evaluate(with: self)
    }

    var isValidPhoneNo: Bool {
        let phoneCharacters = CharacterSet(charactersIn: "+0123456789").inverted
        let arrCharacters = components(separatedBy: phoneCharacters)
        return self == arrCharacters.joined(separator: "")
    }
}

extension String {
    func getWidth(font: UIFont) -> CGFloat {
        let bounds = (self as NSString).size(withAttributes: [.font: font])
        return bounds.width
    }

    func getHeight(font: UIFont) -> CGFloat {
        let bounds = (self as NSString).size(withAttributes: [.font: font])
        return bounds.height
    }
}

extension String {
    var jsonToDictionary: [String: Any]? {
        if let data = data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: [])
                    as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

// For htmlToString convertion
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue,
                ], documentAttributes: nil)
        } catch {
            return nil
        }
    }

    var htmlToString: String {
        htmlToAttributedString?.string ?? ""
    }
}

extension String {
    func toJSON() -> Any? {
        guard let data = data(using: .utf8, allowLossyConversion: false) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(
            with: data, options: .mutableContainers)
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(
            width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect, options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font], context: nil)

        return boundingBox.height
    }
}

extension String {
    func getIntegerValue() -> String {
        let value = self
        let okayChars: Set<Character> =
            Set("1234567890")
        let output = String(value.filter { okayChars.contains($0) })
        print(output)
        return output
    }
}

extension StringProtocol {  // for Swift 4 you need to add the constrain `where Index == String.Index`
    var byWords: [SubSequence] {
        var byWords: [SubSequence] = []
        enumerateSubstrings(in: startIndex..., options: .byWords) {
            _, range, _, _ in
            byWords.append(self[range])
        }
        return byWords
    }
}

//extension String {
//    func localized(withComment comment: String? = nil) -> String {
//           return NSLocalizedString(self, tableName: nil, bundle: .main, value: "", comment: comment ?? "")
//       }
//
//}
