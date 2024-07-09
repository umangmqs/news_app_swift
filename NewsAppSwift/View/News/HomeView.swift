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
    
    @Namespace var nameSpace
    
    @State var arrFeedMenu: [MDLFeedMenu] = [
        MDLFeedMenu(title: "Feeds", selected: true),
        MDLFeedMenu(title: "Popular", selected: false),
        MDLFeedMenu(title: "Following", selected: false)
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
                                        router.navigate(to: .newsDetail)
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
                            NewsCell(data: data)
                        }
                    } else {
                        Text("NO DATA FOUND")
                            .font(.montserrat(.bold, size: 24.aspectRatio))
                            .foregroundStyle(.appPrimaryLight)
                            .padding(.top, 60.aspectRatio)
                    }
                    
                } else if selectedIndex == 1 {
                    ForEach(0..<10, id: \.self) { _ in
                        NewsCell()
                    }
                } else {
                    ForEach(0..<10, id: \.self) { _ in
                        NewsCell()
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
            print("Name changed to \(newValue)!")
            if newValue == 0 {
//                homeVM.getFeedData()
            }
        }
        .padding(.horizontal, 16.aspectRatio)
        .toast(toast: $homeVM.toast)
        .loader(loading: homeVM.isLoading)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    HomeView(
        tabVM: TabViewModel(),
        homeVM: HomeViewModel(
            service: HomeViewService()
        )
    )
}


 
