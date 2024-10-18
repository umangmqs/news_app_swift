//
//  SeeAllViewModel.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 11/07/24.
//

import SwiftUI

@MainActor class SeeAllViewModel: ObservableObject {
    let service: SeeAllService
    var topic = ""
    var page = 1
    var isLoadMore = true

    @Published var toast: Toast?
    @Published var isLoading: Bool = false
    @Published var arrArticles = [MDLArticle]()

    init(service: SeeAllService) {
        self.service = service
    }
}

extension SeeAllViewModel {
    func getAllNews() async {
        let params: JSON = [
            "apiKey": newsKey,
            "q": topic,
            "pageSize": 15,
            "sortBy": "publishedAt",
            "page": page
        ]
        isLoading = true

        let result = await service.getNews(method: .get, params: params)

        isLoading = false
        switch result {
        case let .success(response):
            if arrArticles.count < response.totalResults ?? 0 {
                page += 1
                isLoadMore = true
            }
            arrArticles.append(contentsOf: response.articles ?? [])
        case let .failure(failure):
            toast = Toast(message: failure.localizedDescription)
        }
    }
}
