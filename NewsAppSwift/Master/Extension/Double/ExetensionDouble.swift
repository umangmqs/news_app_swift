//
//  ExetensionDouble.swift
//  mrsnark
//
//  Created by MQF-6 on 15/02/23.
//

import Foundation
import UIKit

extension Double {
    var toInt:Int? {
        return Int(self)
    }
    
    var toDouble:Double? {
        return Double(self)
    }
    
    var toString:String {
        return "\(self)"
    }
    
    var toCGFloat:CGFloat {
        return CGFloat(self)
    }
    
    var aspectRatio: CGFloat {
        return UIDevice.screenWidth * (self.toCGFloat / UIDevice.width)
    }
}
