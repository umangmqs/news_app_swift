//
//  SeeAllView.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 11/07/24.
//

import SwiftUI

struct SeeAllView: View {
    @EnvironmentObject private var router: Router

    @Environment(\.dismiss) var dismiss
    @StateObject var seeAllVM: SeeAllViewModel
    @StateObject var newsDetailVM: NewsDetailViewModel

    var body: some View {
        VStack {
            AppNavigationBar(
                type: .titleAndLeading, searchText: .constant(""),
                leadingAction: {
                    dismiss()
                },
                leadingImage: .icBack,
                title: seeAllVM.topic
            )

            if seeAllVM.arrArticles.isEmpty {
                List(seeAllVM.arrArticles, id: \.id) { data in
                    NewsCell(data: data) { article in
                        newsDetailVM.article = article
                        router.push(to: .newsDetail)
                    }
                    .task {
                        if seeAllVM.isLoadMore, seeAllVM.arrArticles.isLastItem(data) {
                            await seeAllVM.getAllNews()
                        }
                    }
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
                .listRowInsets(.none)
            } else {
                NewsCell(data: newsDetailVM.article) { article in
                    newsDetailVM.article = article
                    router.push(to: .newsDetail)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 16.aspectRatio)
        .navigationBarBackButtonHidden()
        .toast(toast: $seeAllVM.toast)
        .loader(loading: seeAllVM.isLoading)
        .task {
            await seeAllVM.getAllNews()
        }
    }
}

#Preview {
    SeeAllView(
        seeAllVM: SeeAllViewModel(
            service: SeeAllService()
        ),
        newsDetailVM: NewsDetailViewModel(
            appWrite: Appwrite()
        )
    )
}
