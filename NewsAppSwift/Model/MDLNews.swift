//
//  MDLNews.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 09/07/24.
//

import Foundation

struct MDLNews: Identifiable, Codable {
    var id: UUID = .init()
    let articles: [MDLArticle]?
    let status: String?
    let totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case articles
        case status
        case totalResults
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        articles = try values.decodeIfPresent([MDLArticle].self, forKey: .articles)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        totalResults = try values.decodeIfPresent(Int.self, forKey: .totalResults)
    }
}

struct MDLArticle: Codable, Identifiable, Equatable {
    static func == (lhs: MDLArticle, rhs: MDLArticle) -> Bool {
        lhs.id == rhs.id
    }

    var id: UUID = .init()
    let author: String?
    let content: String?
    let descriptionField: String?
    let publishedAt: String?
    let source: MDLSource?
    let title: String?
    let url: String?
    let urlToImage: String?

    enum CodingKeys: String, CodingKey {
        case author
        case content
        case descriptionField = "description"
        case publishedAt
        case source
        case title
        case url
        case urlToImage
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        author = try values.decodeIfPresent(String.self, forKey: .author)
        content = try values.decodeIfPresent(String.self, forKey: .content)
        descriptionField = try values.decodeIfPresent(String.self, forKey: .descriptionField)
        publishedAt = try values.decodeIfPresent(String.self, forKey: .publishedAt)
        source = try values.decodeIfPresent(MDLSource.self, forKey: .source)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        urlToImage = try values.decodeIfPresent(String.self, forKey: .urlToImage)
    }
}

struct MDLSource: Codable, Identifiable {
    let id: UUID = .init()
    let sourceId: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case sourceId = "id"
        case name
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sourceId = try values.decodeIfPresent(String.self, forKey: .sourceId)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
}
