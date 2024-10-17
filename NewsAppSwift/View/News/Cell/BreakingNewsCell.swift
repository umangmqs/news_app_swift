//
//  BreakingNewsCell.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 03/07/24.
//

import SDWebImageSwiftUI
import SwiftUI

struct BreakingNewsCell: View {
    var data: MDLArticle
    var onTap: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            //            Image(.icNews)
            ZStack {
                Color.appGreyLight
                Image(.icNewsPlaceholder)
            }

            WebImage(url: URL(string: data.urlToImage ?? ""))
                .resizable()
                .scaledToFill()
                .transition(.fade(duration: 1))
        }
        .frame(width: 263.aspectRatio, height: 206.aspectRatio)
        .corner(radius: 12.aspectRatio)
        .overlay {
            VStack(alignment: .leading) {
                Spacer()
                HStack {
                    Text(data.source?.name ?? "")
                    Circle()
                        .fill(.appGrey.opacity(0.4))
                        .frame(width: 4.aspectRatio, height: 4.aspectRatio)
                    Text(Date(iso8601String: data.publishedAt ?? "")?.convertToTimezone(.current).formattedRelativeString() ?? "")
                }
                .lineLimit(1)
                .font(.lato(.medium, size: 12))

                Text(data.title ?? "")
                    .font(.lato(.bold, size: 14))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
            }
            .foregroundStyle(.white)
            .padding(16.aspectRatio)
        }
        .onTapGesture {
            onTap()
        }
    }
}
