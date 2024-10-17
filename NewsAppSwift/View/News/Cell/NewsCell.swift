//
//  NewsCell.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 02/07/24.
//

import SDWebImageSwiftUI
import SwiftUI

struct NewsCell: View {
    var data: MDLArticle?
    var onTap: (MDLArticle) -> Void

    var body: some View {
        HStack(spacing: 16.aspectRatio) {
            ZStack {
                Color.appGreyLight

                Image(.icNewsPlaceholder)
                    .resizable()
                    .frame(width: 50.aspectRatio, height: 50.aspectRatio)
                    .foregroundStyle(.white)

                WebImage(url: URL(string: data?.urlToImage ?? ""))
                    .resizable()
                    .scaledToFill()
                    .transition(.fade)
            }
            .frame(width: 144.aspectRatio, height: 116.aspectRatio)
            .corner(radius: 12.aspectRatio)

            VStack(alignment: .leading, spacing: 8.aspectRatio) {
//                Text("Travel")
//                    .font(.lato(size: 12))
//                    .foregroundStyle(.appGrey)

                Text(data?.title ?? "")
                    .font(.lato(.medium, size: 14))
                    .lineLimit(3)

                HStack {
                    Text(data?.source?.name ?? "")
                        .font(.lato(size: 12))
                        .foregroundStyle(.appGrey)

                    Circle()
                        .fill(.appGrey)
                        .frame(width: 4.aspectRatio, height: 4.aspectRatio)

                    Text(Date(iso8601String: data?.publishedAt ?? "")?.convertToTimezone(.current).formattedRelativeString() ?? "")
                        .font(.lato(size: 12))
                        .foregroundStyle(.appGrey)
                }
                .lineLimit(2)
            }
            Spacer()
        }
        .onTapGesture {
            if data != nil {
                onTap(data!)
            }
        }
        .padding(.bottom, 12.aspectRatio)
    }
}

#Preview {
    NewsCell { _ in
    }
}
