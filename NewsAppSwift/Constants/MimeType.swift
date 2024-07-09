//
//  MimeType.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 08/07/24.
//

import Foundation

enum MimeType: String {
    case css = "text/css"
    case json = "application/json"
    case png = "image/png"
    case jpeg = "image/jpeg"
    case gif = "image/gif"
    case mp4 = "video/mp4"
    case mp3 = "audio/mpeg"
    case pdf = "application/pdf"
    case zip = "application/zip"
    
    // Add more MIME types as needed
    
    // A computed property to get the MIME type as a string
    var type: String {
        return self.rawValue
    }
    
    // An initializer that takes a MIME type string and returns the corresponding enum case if it exists
    init?(type: String) {
        self.init(rawValue: type)
    }
}
