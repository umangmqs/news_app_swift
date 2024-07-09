//
//  Costants.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 03/07/24.
//

import Foundation

let CGCDMainThread = DispatchQueue.main
let CGCDBackgroundThread = DispatchQueue.global(qos: .background)

typealias JSON = [String: Any]

let newsKey = "eb40bb38dfbc45e2bae6b2f1a11c5a27"
let projectId = "667e46960005d9cb1338"
let databaseId = "668baef400337460e110"
let storageId = "668bc45f000e97dd51ad"

class Constants {
    static var userInfo: MDLUser!
}

struct StorageKey {
    static let onboarded = "onboarded"
    static let userInfo = "userInfo"
    static let sessionId = "sessionId"
    static let remembarEmail = "remembarEmail"
    static let remembarPass = "remembarPass"
}
