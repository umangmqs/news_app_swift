//
//  SegmentedView.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 03/07/24.
//

import SwiftUI

struct SegmentedView: View {
    @Binding var arrFeedMenu: [MDLFeedMenu]
    @Binding var selectedIndex: Int
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(arrFeedMenu.indices, id: \.self) { index in
                HomeFeedView(feedMenu: arrFeedMenu[index], isSelected: index == selectedIndex, totalCount: arrFeedMenu.count) {
                    withAnimation {
                        selectedIndex = index
                        for i in arrFeedMenu.indices {
                            arrFeedMenu[i].selected = (i == selectedIndex)
                        }
                    }
                }
            }
        }
        .background(
            GeometryReader { geometry in
                Color.white
                    .frame(width: (geometry.size.width) / CGFloat(arrFeedMenu.count), height: 28.aspectRatio)
                    .cornerRadius(20.aspectRatio)
                    .offset(x: CGFloat(selectedIndex) * (geometry.size.width) / CGFloat(arrFeedMenu.count))
                    .animation(.easeInOut(duration: 0.3), value: selectedIndex)
            }
            .clipped() // Prevents the background from overflowing
        )
    }
}
