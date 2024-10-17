//
//  HomeView.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 02/07/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var router: Router
    @StateObject var tabVM: TabViewModel
    @StateObject var homeVM: HomeViewModel
    @StateObject var newsDetailVM: NewsDetailViewModel

    @State var arrFeedMenu: [MDLFeedMenu] = [
        MDLFeedMenu(title: "Feeds", selected: true),
        MDLFeedMenu(title: "Popular", selected: false),
    ]

    @State private var selectedIndex: Int = 0

    var body: some View {
        VStack {
            AppNavigationBar(
                type: .multipleTrailingWithProfile,
                searchText: .constant(""),
                trailingAction: {
                    tabVM.selection = 1
                },
                trailing2Action: {
                    AppPrint.debugPrint("Menu")
                },
                trailingImage: .icSearch,
                traling2Image: .icOption
            )

            ScrollView {
                if homeVM.bannerData?.articles?.count ?? 0 > 0 {
                    VStack {
                        TitleSeeMore(title: "Breaking News") {
                            AppPrint.debugPrint("Breaking News See more")
                        }
                        .padding(.top, 16.aspectRatio)

                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(homeVM.bannerData!.articles!, id: \.id) { data in
                                    BreakingNewsCell(data: data) { 
                                        newsDetailVM.article = data
                                        router.push(to: .newsDetail)
                                    }
                                }
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                }

                RoundedRectangle(cornerRadius: 25.0.aspectRatio)
                    .fill(.appPrimary)
                    .frame(height: 40.aspectRatio)
                    .overlay {
                        HStack {
                            SegmentedView(
                                arrFeedMenu: $arrFeedMenu,
                                selectedIndex: $selectedIndex
                            )
                        }
                    }
                    .padding(.top, 20.aspectRatio)
                    .padding(.bottom, 16.aspectRatio)

                if selectedIndex == 0 {
                    if homeVM.feedData?.articles?.count ?? 0 > 0 {
                        ForEach(homeVM.feedData!.articles!, id: \.id) { data in
                            NewsCell(data: data) { _ in
                                newsDetailVM.article = data
                                router.push(to: .newsDetail)
                            }
                        }
                    } else {
                        noDataView
                    }

                } else if selectedIndex == 1 {
                    if homeVM.popularData?.articles?.count ?? 0 > 0 {
                        ForEach(homeVM.popularData!.articles!, id: \.id) { data in
                            NewsCell(data: data) { _ in
                                newsDetailVM.article = data
                                router.push(to: .newsDetail)
                            }
                        }
                    } else {
                        noDataView
                    }
                }
            }
            .scrollIndicators(.hidden)
            .ignoresSafeArea(edges: .bottom)

            Spacer()
        }
        .onFirstAppear {
            Task {
                await homeVM.getBannerData()

                await homeVM.getFeedData()
            }
        }
        .onChange(of: selectedIndex) { newValue in
            print("\("Name changed to") \(newValue)!")
            Task {
                if newValue == 0 {
                    if homeVM.feedData == nil {
                        await homeVM.getFeedData()
                    }
                } else if newValue == 1 {
                    if homeVM.popularData == nil {
                        await homeVM.getPopularData()
                    }
                } else {}
            }
        }
        .padding(.horizontal, 16.aspectRatio)
        .toast(toast: $homeVM.toast)
        .loader(loading: homeVM.isLoading)
        .navigationBarBackButtonHidden()
    }
}

extension HomeView {
    var noDataView: some View {
        Text(LocalizedStringKey("NO DATA FOUND"))
            .font(.montserrat(.bold, size: 24.aspectRatio))
            .foregroundStyle(.appPrimaryLight)
            .padding(.top, 60.aspectRatio)
    }
}

#Preview {
    HomeView(
        tabVM: TabViewModel(),
        homeVM: HomeViewModel(
            service: HomeViewService()
        ),
        newsDetailVM: NewsDetailViewModel(appWrite: Appwrite())
    )
}
