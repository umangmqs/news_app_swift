//
//  HomeViewModel.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 09/07/24.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    let service: HomeViewService
    
    @Published var isLoading: Bool = false
    @Published var toast: Toast?
    
    @Published var bannerData: MDLNews?
    @Published var feedData: MDLNews?
    
    init(service: HomeViewService) {
        self.service = service
    }
}

extension HomeViewModel {
    func getBannerData() async {
        self.isLoading = true
        let params: JSON = [
            "apiKey": newsKey,
            "country": "in",
            "category": "",
            "pageSize": 10,
            "sortBy": "publishedAt"
        ]
        service.getBannerData(method: .get, params: params) { result in
            CGCDMainThread.async { [weak self] in
                guard let `self` = self else {
                    return
                }
                isLoading = false
                switch result {
                case .success(let response):
                    withAnimation {
                        self.bannerData = response
                    }
                case .failure(let failure):
                    toast = Toast(message: failure.localizedDescription)
                }
            }
        }
    }
    
    func getFeedData() async {
        self.isLoading = true
        let params: JSON = [
            "apiKey": newsKey,
            "q": "india",
            "pageSize": 15,
            "sortBy": "publishedAt"
        ]
        
        service.getFeedData(method: .get, params: params) { result in
            CGCDMainThread.async { [weak self] in
                guard let `self` = self else {
                    return
                }
                isLoading = false
                switch result {
                case .success(let response):
                    withAnimation {
                        self.feedData = response
                    }
                case .failure(let failure):
                    toast = Toast(message: failure.localizedDescription)
                }
            }
        }
    }
}
