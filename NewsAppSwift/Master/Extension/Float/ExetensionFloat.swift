//
//  ExetensionFloat.swift
//  Swifty_Master
//
//  Created by Mac-0002 on 10/11/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import UIKit

extension Float {
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
