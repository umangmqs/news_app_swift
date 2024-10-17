//
//  MDLUser.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 08/07/24.
//

import Foundation

struct MDLUser: Codable {
    var userId: String
    var fullname: String?
    var phone: String?
    var email: String?
    var createdAt: String?
    var updatedAt: String?
    var profileImage: String?

    init(userId: String, fullname: String? = nil, phone: String? = nil, email: String? = nil, createdAt: String? = nil, updatedAt: String? = nil, profileImage: String? = nil) {
        self.userId = userId
        self.fullname = fullname
        self.phone = phone
        self.email = email
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.profileImage = profileImage
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fullname = try container.decodeIfPresent(String.self, forKey: .fullname)
        userId = try container.decodeIfPresent(String.self, forKey: .userId) ?? ""
        email = try container.decodeIfPresent(String.self, forKey: .email)
        phone = try container.decodeIfPresent(String.self, forKey: .phone)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
        profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage)
    }
}
