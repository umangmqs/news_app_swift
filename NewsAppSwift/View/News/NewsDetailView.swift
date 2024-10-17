//
//  NewsDetailView.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 09/07/24.
//

import SDWebImageSwiftUI
import SwiftUI

struct NewsDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var scale: Double = 1
    @StateObject var newsDetailVM: NewsDetailViewModel

    var body: some View {
        VStack {
            AppNavigationBar(
                type: .multipleTrailingWithBack,
                searchText: .constant(""),
                leadingAction: {
                    dismiss.callAsFunction()
                },
                trailingAction: {
                    Task {
                        await newsDetailVM.addRemoveBookmark()
                    }
                },
                trailing2Action: {
                    let shareActivity = UIActivityViewController(activityItems: ["\(newsDetailVM.article?.title ?? "")\n\n\(newsDetailVM.article?.url ?? "")"], applicationActivities: nil)
                    if let vc = UIApplication.shared.topMostVC() {
                        shareActivity.popoverPresentationController?.sourceView = vc.view
                        vc.present(shareActivity, animated: true, completion: nil)
                    }
                },
                leadingImage: .icBack,
                trailingImage: newsDetailVM.isBookmarked ? .icBookmark : .icBookmarkUnfilled,
                traling2Image: .icShare
            )
            .padding(.horizontal, 16.aspectRatio)

            ZStack(alignment: .bottom) {
                WebView(url: newsDetailVM.article?.url ?? "")
                    .scaleEffect(scale)
            }
        }
        .navigationBarBackButtonHidden()
        .toast(toast: $newsDetailVM.toast)
        .loader(loading: newsDetailVM.isLoading)
        .task {
            await newsDetailVM.getIsBookmarked()
        }
    }
}

extension NewsDetailView {
    var newsContentView: some View {
        VStack(alignment: .leading) {
            Text(newsDetailVM.article?.title ?? "")
                .font(.lato(.medium, size: 20 * scale))
                .padding(.top, 34.aspectRatio)

            HStack {
                Text(newsDetailVM.article?.source?.name ?? "")
                RoundedRectangle(cornerRadius: 2.aspectRatio)
                    .frame(width: 3.aspectRatio, height: 3.aspectRatio)

                Text(Date(iso8601String: newsDetailVM.article?.publishedAt ?? "")?.convertToTimezone(.current).formattedRelativeString() ?? "")
            }
            .font(.lato(size: 12 * scale))
            .foregroundStyle(.appGrey)

            ZStack {
                ZStack {
                    Color.appGreyLight
                    Image(.icNewsPlaceholder)
                }
                WebImage(url: URL(string: newsDetailVM.article?.urlToImage ?? ""))
                    .resizable()
                    .transition(.fade(duration: 0.4))
            }
            .frame(height: 220.aspectRatio * scale)
            .corner(radius: 16.aspectRatio)
            .padding(.top, 10.aspectRatio)

            HStack {
                Spacer()
                Text(newsDetailVM.article?.author ?? "")
                    .font(.lato(size: 12 * scale))
                    .foregroundStyle(.appGrey)
                    .padding(.top, 2.aspectRatio)
                    .padding(.bottom, 8.aspectRatio)
                Spacer()
            }

            Text(newsDetailVM.article?.content ?? "")
                .font(.lato(size: 14 * scale))
        }
    }
}

#Preview {
    NewsDetailView(
        newsDetailVM: NewsDetailViewModel(
            appWrite: Appwrite()
        )
    )
}
