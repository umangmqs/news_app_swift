//
//  AppPrint.swift
//  DeliveryApp
//
//  Created by MQF-6 on 09/02/24.
//

import Foundation

class AppPrint {
    static func debugPrint(_ data: Any) {
        #if DEBUG
            print(data)
        #endif
    }
}
