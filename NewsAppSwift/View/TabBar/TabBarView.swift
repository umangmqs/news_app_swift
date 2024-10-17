//
//  TabBarView.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 03/07/24.
//

import SwiftUI

struct TabBarView: View {
    @StateObject var tabVM: TabViewModel
    
    let homeVM: HomeViewModel
    let profileVM: ProfileViewModel
    let newsDetailVM: NewsDetailViewModel
    let seeAllVM: SeeAllViewModel
    let bookmarkVM: BookmarkViewModel
    
    var body: some View {
        TabView(selection: tabVM.binding(for: \.selection)) {
            HomeView(
                tabVM: tabVM,
                homeVM: homeVM,
                newsDetailVM: newsDetailVM
            )
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(0)
            
            ExploreView(
                exploreVM: ExploreViewModel(
                    service: ExploreService()
                ),
                newsDetailVM: newsDetailVM,
                seeAllVM: seeAllVM
            )
            .tabItem {
                Label("Explore", systemImage: "safari.fill")
            }
            .tag(1)
            
            BookmarkView(
                bookmarkVM: bookmarkVM,
                newsDetailVM: newsDetailVM
            )
            .tabItem {
                Label("Bookmark", systemImage: "bookmark.fill")
            }
            .tag(2)
            
            ProfileView(
                profileVM: profileVM
            )
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle.fill")
            }
            .tag(3)
        }
        .tint(.white)
        .onAppear {
            UITabBar.appearance().backgroundColor = .appPrimary
            UITabBar.appearance().unselectedItemTintColor = .appPrimaryLight
        }
        .navigationBarBackButtonHidden()
    }
}
