//
//  TitleSeeMore.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 02/07/24.
//

import SwiftUI

struct TitleSeeMore: View {
    var title: String
    var onSeeMore: () -> Void

    var body: some View {
        HStack {
            Text(title)
                .font(.lato(.medium, size: 16))

            Spacer()

            Button(action: {
                onSeeMore()
            }, label: {
                Text("See More")
                    .font(.lato(size: 12))
                    .foregroundStyle(.appPrimary)
            })
        }
        .padding(.bottom, 16.aspectRatio)
    }
}

#Preview {
    TitleSeeMore(title: "Hello") {
        AppPrint.debugPrint("asfasdf")
    }
}
