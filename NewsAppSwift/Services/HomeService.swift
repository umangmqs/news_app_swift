//
//  HomeService.swift
//  SimpleListExample
//
//  Created by Umang on 19/07/23.
//

import Foundation

protocol HomeViewDelegate: AnyObject {
    func getBannerData(method: HTTPMethod, params: JSON) async -> Result<MDLNews, APIError>
    func getFeedData(method: HTTPMethod, params: JSON) async -> Result<MDLNews, APIError>
    func getPopularData(method: HTTPMethod, params: JSON) async -> Result<MDLNews, APIError>
}

class HomeViewService: HomeViewDelegate {
    func getBannerData(method: HTTPMethod, params: JSON) async -> Result<MDLNews, APIError> {
        do {
            let newsData = try await NetworkManager.shared.fetchRequest(
                method: method,
                endpoint: .headline,
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

    func getFeedData(method: HTTPMethod, params: JSON) async -> Result<MDLNews, APIError> {
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

    func getPopularData(method: HTTPMethod, params: JSON) async -> Result<MDLNews, APIError> {
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
