//
//  MDLBookmark.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 09/10/24.
//


struct MDLBookmark: Codable {
    let userId: String
    let url: String
    let article: MDLArticle
    
    enum CodingKeys: CodingKey {
        case userId
        case url
        case article
    }
    
    init(userId: String, url: String, article: MDLArticle) {
        self.userId = userId
        self.url = url
        self.article = article
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.url = try container.decode(String.self, forKey: .url)
        self.article = try container.decode(MDLArticle.self, forKey: .article)
    }
}
