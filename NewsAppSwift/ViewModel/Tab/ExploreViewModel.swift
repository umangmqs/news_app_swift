//
//  ExploreViewModel.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 11/07/24.
//

import Combine
import Foundation

class ExploreViewModel: ObservableObject {
    let service: ExploreService

    @Published var toast: Toast?
    @Published var isLoading: Bool = false

    @Published var search = ""

    private var newsDataTmp: [String: [MDLArticle]] = [:]
    @Published var newsData: [(key: String, value: [MDLArticle])] = []

    @Published var searchData: [MDLArticle] = []

    var cancellable = Set<AnyCancellable>()

    let stateCountry = [
        "Gujarat"
        //        "Maharastra",
        //        "Rajasthan",
        //        "India",
        //        "United States",
        //        "United Kingdom",
        //        "Russia",
        //        "China",
    ]

    init(service: ExploreService) {
        self.service = service

        $search
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                Task {
                    await self?.getSearchData()
                }
            }
            .store(in: &cancellable)
    }
}

extension ExploreViewModel {
    private func fetchArticles(for country: String) async throws -> [MDLArticle] {
        let params: JSON = [
            "apiKey": newsKey,
            "q": country,
            "pageSize": 5
        ]

        let result = await service.getNewsByCountry(
            method: .get, params: params)
        switch result {
        case let .success(response):
            return response.articles ?? []
        case let .failure(error):
            toast = Toast(message: error.localizedDescription)
            return []
        }
    }

    @MainActor
    func getNewsByCountry() async {
        do {
            for sc in stateCountry {
                isLoading = true
                let articles = try await fetchArticles(for: sc)
                isLoading = false

                newsDataTmp.updateValue(articles, forKey: sc)
                newsData = newsDataTmp.sorted { $0.key < $1.key }
            }

        } catch {
            toast = Toast(message: error.localizedDescription)
        }
    }

    @MainActor
    func getSearchData() async {
        let params: JSON = [
            "apiKey": newsKey,
            "q": search,
            "pageSize": 10
        ]
        isLoading = true
        let result = await service.getNewsBySearching(
            method: .get, params: params)

        isLoading = false
        switch result {
        case let .success(response):
            searchData = response.articles ?? []
        case let .failure(failure):
            toast = Toast(message: failure.localizedDescription)
        }
    }
}
