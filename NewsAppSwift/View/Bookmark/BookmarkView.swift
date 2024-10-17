//
//  BookmarkView.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 03/07/24.
//

import SwiftUI

struct BookmarkView: View {
    @EnvironmentObject var router: Router
    @StateObject var bookmarkVM: BookmarkViewModel
    @StateObject var newsDetailVM: NewsDetailViewModel

    var body: some View {
        VStack {
            AppNavigationBar(
                type: .title, searchText: .constant(""), title: "Bookmarks")
            
            
            ScrollView {
                ForEach(bookmarkVM.arrBookmark, id: \.article.id) { bookmark in
                    NewsCell(data: bookmark.article) { article in
                        newsDetailVM.article = article
                        router.push(to: .newsDetail)
                    }
                }
            }
            .padding(.horizontal, 16.aspectRatio)
        }
        .toast(toast: $bookmarkVM.toast)
        .loader(loading: bookmarkVM.isLoading)
        .task {
            await bookmarkVM.getBookmarks()
        }
    }
}

#Preview {
    BookmarkView(
        bookmarkVM: BookmarkViewModel(appWrite: Appwrite()),
        newsDetailVM: NewsDetailViewModel(appWrite: Appwrite())
    )
}
