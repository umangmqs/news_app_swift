//
//  HomeViewModel.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 09/07/24.
//

import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    let service: HomeViewService

    @Published var isLoading: Bool = false
    @Published var toast: Toast?

    @Published var bannerData: MDLNews?
    @Published var feedData: MDLNews?
    @Published var popularData: MDLNews?

    init(service: HomeViewService) {
        self.service = service
    }
}

extension HomeViewModel {
    func getBannerData() async {
        let params: JSON = [
            "apiKey": newsKey,
            "country": "in",
            "category": "",
            "pageSize": 10,
            "sortBy": "publishedAt"
        ]

        isLoading = true

        let result = await service.getBannerData(method: .get, params: params)
        isLoading = false

        isLoading = false
        switch result {
        case let .success(response):
            bannerData = response
        case let .failure(failure):
            toast = Toast(message: "\(failure)")
        }
    }

    func getFeedData() async {
        let params: JSON = [
            "apiKey": newsKey,
            "q": "india",
            "pageSize": 15,
            "sortBy": "publishedAt"
        ]

        isLoading = true
        let result = await service.getFeedData(method: .get, params: params)
        isLoading = false

        switch result {
        case let .success(response):
            withAnimation {
                self.feedData = response
            }
        case let .failure(failure):
            toast = Toast(message: "\(failure)")
        }
    }

    @MainActor
    func getPopularData() async {
        isLoading = true

        let params: JSON = [
            "apiKey": newsKey,
            "q": "india",
            "pageSize": 15,
            "page": 2,
            "sortBy": "publishedAt"
        ]

        let result = await service.getPopularData(method: .get, params: params)

        isLoading = false
        switch result {
        case let .success(response):
            withAnimation {
                self.popularData = response
            }
        case let .failure(failure):
            toast = Toast(message: "\(failure)")
        }
    }
}
