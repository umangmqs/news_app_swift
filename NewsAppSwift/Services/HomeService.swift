//
//  HomeService.swift
//  SimpleListExample
//
//  Created by Umang on 19/07/23.
//

import Foundation
 
protocol HomeViewDelegate {
    func getBannerData(method: HTTPMethod, params: JSON, completion: @escaping(Result<MDLNews, APIError>) -> Void)
    func getFeedData(method: HTTPMethod, params: JSON, completion: @escaping(Result<MDLNews, APIError>) -> Void)
}

class HomeViewService: HomeViewDelegate {
    func getBannerData(method: HTTPMethod, params: JSON, completion: @escaping (Result<MDLNews, APIError>) -> Void) {
        NetworkManager.shared.fetchRequest(
            method: .get,
            endpoint: .headline,
            params: params,
            type: MDLNews.self,
            completion: completion
        )
    }
    
    func getFeedData(method: HTTPMethod, params: JSON, completion: @escaping (Result<MDLNews, APIError>) -> Void) {
        NetworkManager.shared.fetchRequest(
            method: .get,
            endpoint: .headline,
            params: params,
            type: MDLNews.self,
            completion: completion
        )
    }
}

