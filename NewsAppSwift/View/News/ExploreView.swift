//
//  ExploreView.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 02/07/24.
//

import SwiftUI

struct ExploreView: View {
    @EnvironmentObject private var router: Router

    @StateObject var exploreVM: ExploreViewModel
    @StateObject var newsDetailVM: NewsDetailViewModel
    @StateObject var seeAllVM: SeeAllViewModel

    var body: some View {
        VStack {
            AppNavigationBar(
                type: .searchWithLeadingTrailing,
                searchText: $exploreVM.search,
                trailingImage: .icOption
            )

            ScrollView {
                VStack(spacing: 16.aspectRatio) {
                    if exploreVM.searchData != [] {
                        ForEach(exploreVM.searchData, id: \.id) { article in
                            NewsCell(data: article) { data in
                                newsDetailVM.article = data
                                router.push(to: .newsDetail)
                            }
                        }
                    } else {
                        ForEach(exploreVM.newsData.indices, id: \.self) { index in
                            VStack {
                                TitleSeeMore(title: "\("Trending in".localiz()) \(exploreVM.newsData[index].key)") {
                                    seeAllVM.topic = exploreVM.newsData[index].key
                                    router.push(to: .seeAllNews)
                                }

                                ForEach(exploreVM.newsData[index].value) { article in
                                    NewsCell(data: article) { data in
                                        newsDetailVM.article = data
                                        router.push(to: .newsDetail)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.top, 20.aspectRatio)
            }
            .scrollIndicators(.hidden)

            Spacer()
        }
        .padding(.horizontal, 16.aspectRatio)
        .loader(loading: exploreVM.isLoading)
        .toast(toast: $exploreVM.toast)
        .onFirstAppear {
            Task {
                await exploreVM.getNewsByCountry()
            }
        }
    }
}

#Preview {
    ExploreView(
        exploreVM: ExploreViewModel(
            service: ExploreService()
        ),
        newsDetailVM: NewsDetailViewModel(
            appWrite: Appwrite()
        ),
        seeAllVM: SeeAllViewModel(
            service: SeeAllService()
        )
    )
}
