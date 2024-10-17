//
//  SeeAllService.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 11/07/24.
//

import Foundation

protocol SeeAllServiceDelegate {
    func getNews(method: HTTPMethod, params: JSON) async -> Result<MDLNews, APIError>
}

class SeeAllService: SeeAllServiceDelegate {
    func getNews(method: HTTPMethod, params: JSON) async -> Result<MDLNews, APIError> {
        do {
            let newsData = try await NetworkManager.shared.fetchRequest(
                method: method,
                endpoint: .everything,
                params: params,
                type: MDLNews.self
            )
            return .success(newsData)
        } catch let error as APIError {
            return .failure(error)
        } catch {
            return .failure(.decodingError)
        }
    }
}
