//
//  ExetensionDouble.swift
//  mrsnark
//
//  Created by MQF-6 on 15/02/23.
//

import Foundation
import UIKit

extension Double {
    var toInt: Int? {
        Int(self)
    }

    var toDouble: Double? {
        Double(self)
    }

    var toString: String {
        "\(self)"
    }

    var toCGFloat: CGFloat {
        CGFloat(self)
    }

    var aspectRatio: CGFloat {
        UIDevice.screenWidth * (toCGFloat / UIDevice.width)
    }
}
