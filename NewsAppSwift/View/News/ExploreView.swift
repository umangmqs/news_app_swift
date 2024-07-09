//
//  HomeView.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 02/07/24.
//

import SwiftUI

struct MDLNewsData: Identifiable {
    var id: UUID = UUID()
    var source: String
    var title: String
    var date: String
    var category: String
}

struct ExploreView: View {
    @State var search = ""
    
    var body: some View {
        VStack {
            AppNavigationBar(type: .searchWithLeadingTrailing, searchText: $search, trailingImage: .icOption)
            
            VStack(spacing: 16.aspectRatio) {
                ScrollView {
                    TitleSeeMore(title: "Trending in Gujarat") {
                        
                    }
                    
                    ForEach(0..<3) { _ in
                        NewsCell()
                    }
                }
                .scrollIndicators(.hidden)
            }
            .padding(.top, 20.aspectRatio)
            
            Spacer()
        }
        .padding(.horizontal, 16.aspectRatio)
    }
}

#Preview {
    ExploreView()
}


