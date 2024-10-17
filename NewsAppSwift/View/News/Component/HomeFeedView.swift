//
//  HomeFeedView.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 09/07/24.
//

import SwiftUI

struct HomeFeedView: View {
    @ObservedObject var feedMenu: MDLFeedMenu
    var isSelected: Bool
    var totalCount: Int
    var onTap: () -> Void

    var body: some View {
        let itemWidth = (UIDevice.screenWidth - 50.aspectRatio) / CGFloat(totalCount)

        Text(LocalizedStringKey(feedMenu.title))
            .font(.montserrat(.medium, size: 14.aspectRatio))
            .foregroundColor(feedMenu.selected ? .black : .white)
            .frame(width: itemWidth, height: 28.aspectRatio)
            .onTapGesture {
                onTap()
            }
    }
}
